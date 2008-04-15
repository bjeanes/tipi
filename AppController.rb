#
#  AppController.rb
#  Tipi
#
#  Created by Bodaniel Jeanes on 15/04/08.
#  Copyright (c) 2008 bjeanes.com. All rights reserved.
#

require 'osx/cocoa'

class AppController < OSX::NSObject
  include OSX
  
  ib_outlets :statusMenu, :window, :username, :password, :interval,
    :onpeak, :offpeak
  
  ib_action :check_usage do |sender|
    @timer.fire
  end
  
  ib_action :save_prefs do |sender|
    @timer.fire
    @window.close
  end
  
  def awakeFromNib
    NSLog("Getting Status Bar")
    @bar = NSStatusBar.systemStatusBar
    @status_item = @bar.statusItemWithLength_(NSVariableStatusItemLength)
		NSLog("Setting status item icon")
		
    # statusImage = OSX::NSImage.alloc.initWithContentsOfFile_(OSX::NSBundle.mainBundle.pathForResource_ofType_("icon","gif"))
    
    @status_item.setTitle("Checking...")
    @status_item.setMenu(@statusMenu)
    @status_item.setToolTip("Click for more information")
    @status_item.setHighlightMode(true)

    interval = user_interval_value || (60.0 * 5.0)
    @timer = NSTimer.scheduledTimerWithTimeInterval_target_selector_userInfo_repeats_(interval, self, :tick!, nil, true)
    @timer.fire # get an initial pull of data
  end
  
  def tick!
    NSLog("Checking Usage...")
    # NSLog(@onpeak.stringValue)
    
    @tipi ||= Tipi.new
    @tipi.set_auth(@username.stringValue.to_s, @password.stringValue.to_s)
    tipi = @tipi.check_usage

    if tipi.nil?
      @status_item.setTitle("Invalid Credentials")
    else
      NSLog(tipi.inspect)
      @status_item.setTitle(tipi[tipi[:current]].to_s + "MB")
    end
  end
  
  def dealloc
    @status_item.release
    @status_item = nil
  end
  
  private
  def user_interval_value
    if val = @interval.floatValue
      val * 60.0
    else  
      nil
    end
  end
end
