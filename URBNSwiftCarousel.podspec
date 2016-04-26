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

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC

URBNSwiftCarousel is a framework for displaying images in a carousel, or a side scrolling collection view.  It includes a transition controller for a custom zooming transition effect to a full screen carousel.
                       DESC

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/URBNSwiftCarousel"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Kevin Taniguchi" => "ktaniguchi@urbn.com" }
  s.source           = { :git => "git@github.com:urbn/URBNSwiftCarousel.git", :tag => s.version.to_s" }

  s.ios.deployment_target = '9.0'

  s.source_files = 'URBNSwiftCarousel/Classes/**/*'
  s.resource_bundles = {
    'URBNSwiftCarousel' => ['URBNSwiftCarousel/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
