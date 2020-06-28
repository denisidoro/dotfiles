function main() {
    const CONFIG_PATH = global('Modes_ConfigPath') || '/sdcard/dotfiles/tasker/configs';
    const ALL_CONFIGS = readConfigs();
    const DEFAULT_CONTEXT = global('Modes_DefaultContext') || 'base';

    let contexts = global('Modes_Contexts').split(',').filter(c => { return (c !== '') });
    let previousContexts = global('Modes_ActiveContexts').split(',').filter(c => { return (c !== '') });

    // Filter down to only configs in %Modes_Contexts
    let configs = ALL_CONFIGS.filter(c => { return contexts.indexOf(c.name) > -1 });
    let defaultContext = (DEFAULT_CONTEXT && typeof DEFAULT_CONTEXT === 'string' ? ALL_CONFIGS.find(c => { return c.name === DEFAULT_CONTEXT }) : null) || { priority: 0 };

    // Determine which contexts will be activated based upon type and priority
    let activeContexts = [];
    let primaryContext = configs.filter(c => { return c.type === 1; }).sort((a, b) => { return a.priority - b.priority; }).pop() || defaultContext;
    let primaryPriority = primaryContext.priority || 0;
    activeContexts.push(primaryContext.name);
    let secondaryContexts = configs.filter(c => { return (c.type === 2 && c.priority >= primaryPriority); }).sort((a, b) => { return a.priority - b.priority; });
    secondaryContexts.forEach(c => {
      activeContexts.push(c.name);
    });

    // Determine which contexts are newly active and inactive
    let newContexts = missingItems(activeContexts, previousContexts);
    let inactivatedContexts = missingItems(previousContexts, activeContexts);

    // Perform exit parameters for inactivated contexts
    ALL_CONFIGS
      .filter(c => { return inactivatedContexts.indexOf(c.name) > -1 })
      .forEach(context => {
        if (context.exit) {
          if (context.exit.profilesToDisable && Array.isArray(context.exit.profilesToDisable)) context.exit.profilesToDisable.forEach(prof => { changeProfileStatus(prof, false); });
          if (context.exit.profilesToEnable && Array.isArray(context.exit.profilesToEnable)) context.exit.profilesToEnable.forEach(prof => { changeProfileStatus(prof, true); });
          if (context.exit.tasksToRun && Array.isArray(context.exit.tasksToRun)) context.exit.tasksToRun.forEach(tsk => {
            if (typeof tsk === 'string') {
              executeTask(tsk, 10, null, null);
            } else if (typeof tsk === 'object' && tsk.name) {
              executeTask(tsk.name, tsk.priority, tsk.param1, tsk.param2);
            }
          });
        }
      });

    const MERGEABLE_KEYS = ['name', 'type', 'priority', 'enter', 'exit'];

    // Merge active context's settings
    let merged = {};
    if (primaryContext) {
      Object.keys(primaryContext).forEach(key => {
        if (MERGEABLE_KEYS.indexOf(key) === -1 && primaryContext[key] !== null) merged[key] = primaryContext[key];
      });
    }
    secondaryContexts.forEach(context => {
      Object.keys(context).forEach(key => {
        if (MERGEABLE_KEYS.indexOf(key) === -1 && context[key] !== null) merged[key] = context[key];
      });
    });

    // Change settings according to merged context
    if (existsIsType(merged, 'volume_media', 'int')) mediaVol(merged.volume_media, false, false);
    if (existsIsType(merged, 'volume_notification', 'int')) notificationVol(merged.volume_notification, false, false);
    if (existsIsType(merged, 'dnd', 'string')) performTask('Do not disturb', 10, merged.dnd, '');
    if (existsIsType(merged, 'location', 'string')) performTask('Location mode', 10, merged.location, '');
    if (existsIsType(merged, 'wifi', 'boolean')) setWifi(merged.wifi);
    if (existsIsType(merged, 'bluetooth', 'boolean')) setBT(merged.bluetooth);
    if (existsIsType(merged, 'mobileData', 'boolean')) performTask('Mobile data', 10, merged.mobileData, '');
    if (existsIsType(merged, 'airplaneMode', 'boolean')) setAirplaneMode(merged.airplaneMode);
    if (existsIsType(merged, 'screenRotation', 'boolean')) performTask('Display Rotation', 10, merged.screenRotation, '');
    if (existsIsType(merged, 'displayTimeout', 'int')) displayTimeout(0, merged.displayTimeout, 0);
    if (existsIsType(merged, 'displayBrightness', 'int') || existsIsType(merged, 'displayBrightness', 'string')) performTask('Display brightness', 10, merged.displayBrightness, '');
    if (existsIsType(merged, 'immersiveMode', 'string')) performTask('Immersive mode', 10, merged.immersiveMode, '');
    if (existsIsType(merged, 'darkMode', 'boolean')) performTask('Dark mode', 10, merged.darkMode, '');
    if (existsIsType(merged, 'hapticFeedback', 'boolean')) performTask('Haptic feedback', 10, merged.hapticFeedbackOn, '');
    if (existsIsType(merged, 'batterySaver', 'boolean')) performTask('Battery saver', 10, merged.batterySaverOn, '');

    // Perform enter parameters for new contexts
    ALL_CONFIGS
      .filter(context => { return (newContexts.indexOf(context.name) > -1) })
      .forEach(context => {
        if (context.enter) {
          if (context.enter.profilesToDisable && Array.isArray(context.enter.profilesToDisable)) context.enter.profilesToDisable.forEach(prof => { changeProfileStatus(prof, false); });
          if (context.enter.profilesToEnable && Array.isArray(context.enter.profilesToEnable)) context.enter.profilesToEnable.forEach(prof => { changeProfileStatus(prof, true); });
          if (context.enter.tasksToRun && Array.isArray(context.enter.tasksToRun)) context.enter.tasksToRun.forEach(tsk => {
            if (typeof tsk === 'string') {
              executeTask(tsk, 10, null, null);
            } else if (typeof tsk === 'object' && tsk.name) {
              executeTask(tsk.name, tsk.priority, tsk.param1, tsk.param2);
            }
          });
        }
      });

    flash((newContexts.length > 0 ? 'New context(s): ' + newContexts.join(', ') : 'Active Context(s): ' + activeContexts.join(', ')));
    setGlobal('Modes_ActiveContexts', activeContexts.join(','));
}

function readConfigs() {
    let configs = [];

    let fileList = listFiles(CONFIG_PATH).split('\n').filter(f => { return (f !== '') });
    fileList.forEach(f => {
      let conf = readConfigFile(f);
      configs.push(conf);
    });

    return JSON.stringify(configs);
}

function readConfigFile(configName) {
  let configText = '{}';
  try {
    configText = readFile(configName);
  } catch (error) {
    flash('Error reading configuration file ' + configName);
  }
  let conf = JSON.parse(configText);
  if (!conf.name) conf.name = configName.replace(/^.*\/|\.[A-Za-z]+$/g, '');
  if (!conf.type) conf.type = 1;
  if (!conf.priority) conf.priority = 50;
  // Translate old configuration format
  if (Object.keys(conf).indexOf('volume') > -1) {
    if (conf.volume.media !== null) conf.volume_media = conf.volume.media;
    if (conf.volume.notification !== null) conf.volume_notification = conf.volume.notification;
    if (conf.volume.dnd !== null) conf.dnd = conf.volume.dnd;
    delete conf.volume;
  }
  return conf;
}

// Helper functions
function missingItems(arr1, arr2) {
  var missing = arr1.filter(function(item) {
    return arr2.indexOf(item) === -1;
  });
  return missing;
}

function existsIsType(obj, key, type) {
  if (Object.keys(obj).indexOf(key) === -1) return false;
  if (type === 'int') return (Number.isInteger(obj[key]));
  else return (typeof obj[key] === type);
}

function changeProfileStatus(name, on) {
  enableProfile(name, on);
  wait(1000);
}

function executeTask(name, priority, param1, param2) {
  performTask(name, priority, param1, param2);
  wait(500);
}
