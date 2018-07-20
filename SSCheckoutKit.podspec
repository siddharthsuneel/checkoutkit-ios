Pod::Spec.new do |s|
  s.name             = 'SSCheckoutKit'
  s.version          = '0.0.1'
  s.summary          = "SSCheckoutKit is the adapter library that can be used for integrating Checkout.com payment."
 
  s.description      = <<-DESC
SSCheckoutKit is adapter library that can be used for integrating Checkout.com payment gateway in any iOS app.
                       DESC
 
  s.homepage         = "https://github.com/siddharthsuneel/checkoutkit-ios"
  s.license          = {
     :type => "DMI",
     :text => <<-LICENSE
               Copyright (C) 2018 DMI

               All rights reserved.
     LICENSE
   }

  s.author           = { "Siddharth Suneel" => "ssuneel@dminc.com" }
  s.source           = { :git => "https://github.com/siddharthsuneel/checkoutkit-ios", :branch => 'master' }

  s.swift_version     		= "4.0"
  s.requires_arc      		= true
  s.platform          		= :ios, "8.0"
  s.ios.deployment_target 	= "8.0"
  s.source_files = 'CheckoutKit/**/*.{swift,h,m}'
  s.exclude_files = 'CheckoutKit/CheckoutKitTests/**'  

end