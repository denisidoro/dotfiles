function main() {
    const CONFIG_PATH = global('Modes_ConfigPath') || '/sdcard/dotfiles/tasker/configs';
    const ALL_CONFIGS = readConfigs(CONFIG_PATH);
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
          if (context.exit.profiles_to_disable && Array.isArray(context.exit.profiles_to_disable)) context.exit.profiles_to_disable.forEach(prof => { changeProfileStatus(prof, false); });
          if (context.exit.profiles_to_enable && Array.isArray(context.exit.profiles_to_enable)) context.exit.profiles_to_enable.forEach(prof => { changeProfileStatus(prof, true); });
          if (context.exit.tasks_to_run && Array.isArray(context.exit.tasks_to_run)) context.exit.tasks_to_run.forEach(tsk => {
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
    if (existsIsType(merged, 'mobile_data', 'boolean')) performTask('Mobile data', 10, merged.mobile_data, '');
    if (existsIsType(merged, 'airplane_mode', 'boolean')) setAirplaneMode(merged.airplane_mode);
    if (existsIsType(merged, 'screen_rotation', 'boolean')) performTask('Display rotation', 10, merged.screen_rotation, '');
    if (existsIsType(merged, 'display_timeout', 'int')) displayTimeout(0, merged.display_timeout, 0);
    if (existsIsType(merged, 'display_brightness', 'int') || existsIsType(merged, 'displayBrightness', 'string')) performTask('Display brightness', 10, merged.display_brightness, '');
    if (existsIsType(merged, 'immersive_mode', 'string')) performTask('Immersive mode', 10, merged.immersive_mode, '');
    if (existsIsType(merged, 'dark_mode', 'boolean')) performTask('Dark mode', 10, merged.dark_mode, '');
    if (existsIsType(merged, 'haptic_feedback', 'boolean')) performTask('Haptic feedback', 10, merged.haptic_feedback, '');
    if (existsIsType(merged, 'battery_saver', 'boolean')) performTask('Battery saver', 10, merged.battery_saver, '');

    // Perform enter parameters for new contexts
    ALL_CONFIGS
      .filter(context => { return (newContexts.indexOf(context.name) > -1) })
      .forEach(context => {
        if (context.enter) {
          if (context.enter.profiles_to_disable && Array.isArray(context.enter.profiles_to_disable)) context.enter.profiles_to_disable.forEach(prof => { changeProfileStatus(prof, false); });
          if (context.enter.profiles_to_enable && Array.isArray(context.enter.profiles_to_enable)) context.enter.profiles_to_enable.forEach(prof => { changeProfileStatus(prof, true); });
          if (context.enter.tasks_to_run && Array.isArray(context.enter.tasks_to_run)) context.enter.tasks_to_run.forEach(tsk => {
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

function readConfigs(config_path) {
    let configs = [];

    let fileList = listFiles(config_path).split('\n').filter(f => { return (f !== '') });
    fileList.forEach(f => {
      let conf = readConfigFile(f);
      configs.push(conf);
    });

    return configs;
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
  return arr1.filter(function(item) {
    return arr2.indexOf(item) === -1;
  });
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
