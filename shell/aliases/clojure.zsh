#alias lr="clear; lein repl"
#alias lm="clear; lein midje"
alias lma="clear; lein midje :autotest"
#alias lp="clear; lein postman"
#alias lpr="clear; lein postman-repl"
#alias lpra="clear; (echo -e \"(autotest)\" && cat) | lein postman-repl"
alias li="clear; lein install"
#alias lcd="clear; lein clean && lein deps"
lpa() { clear; (lein help postman-repl | grep -q args) && ((echo -e "(autotest)" && cat) | lein postman-repl) || (lein postman :autotest); }