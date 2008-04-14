# Tipi

Tipi is or will be an OS X status item that, provided with credentials, will check the data usage for your account on [TPG](http://www.tpg.com.au), an Australian ISP, and display it in a customizable fashion. 

## Currently

This is at the moment just a CLI script written in Ruby to login and parse the HTML from the TPG account page. It uses the parsed data to report on how much data you have used in the current billing cycle.

## Plans

I will be making this into a status item that can be running constantly and will report (and log) current data usage, which period you are in, how long till your quota resets, and an estimate of how much data you can use per day without getting your speed capped. It will also provide a drop-down list of shortcuts to common places on the TPG homepage (Billing, Usage, Email, etc)