#
# Be sure to run `pod lib lint URBNSwiftCarousel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "URBNSwiftCarousel"
  s.version          = "0.1.0"
  s.summary          = "A Carousel for use with Side Scrolling Collection Views."
  s.description      = <<-DESC

URBNSwiftCarousel is a framework for displaying images in a carousel, or a side scrolling collection view.  It includes a transition controller for a custom zooming transition effect to a full screen carousel.
                       DESC

  s.homepage         = "https://github.com/urbn/URBNSwiftCarousel"
  s.license          = 'MIT'
  s.author           = { "Kevin Taniguchi" => "ktaniguchi@urbn.com" }
  s.source           = { :git => "git@github.com:urbn/URBNSwiftCarousel.git", :tag => s.version.to_s }

s.ios.deployment_target = '9.0'

s.source_files = 'URBNSwiftCarousel/Classes/**/*'
end
