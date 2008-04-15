# Tipi

Tipi is or will be an OS X status item that, provided with credentials, will check the data usage for your account on [TPG](http://www.tpg.com.au), an Australian ISP, and display it in a customizable fashion. 

## Currently

<strike>This is at the moment just a CLI script written in Ruby to login and parse the HTML from the TPG account page. It uses the parsed data to report on how much data you have used in the current billing cycle.</strike>

I have spent tonight implementing the very raw beginnings of this application. As it stands at the moment, you can compile and start up the application. An `NSStatusItem` will appear in the menu bar saying "Checking...". Shortly after it will say "Invalid Credentials". To fix this, click on the menu item, and click no Preferences. Here you can put in your TPG username and password, and press Save. Pressing Save will trigger a usage check. At that point the menu bar text will be the number of megabytes used in the current period (on-peak/off-peak).

This is *all* it does so far. Soon both on-peak and off-peak will be shown in the drop down as percentages and GB. Note: Quit and Check Now *do* work.

This has not been extensively tested and will definitely only work on the Super 2 plan (Super 1 as well but with wrong on/off peak times). This will have to be fixed up by others who can test it on their plan, or give me a "View Source" output of their usage page.

## Plans

I will be making this into a status item that can be running constantly and will report (and log) current data usage, which period you are in, how long till your quota resets, and an estimate of how much data you can use per day without getting your speed capped. It will also provide a drop-down list of shortcuts to common places on the TPG homepage (Billing, Usage, Email, etc)