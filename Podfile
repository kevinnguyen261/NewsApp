def module_pod
  pod 'Base', :path => 'Modules/Base'
  pod 'NetworkService', :path => 'Modules/NetworkService'
  pod 'Home', :path => 'Modules/Home'
  pod 'Common', :path => 'Modules/Common'
end

target 'NewsApp' do
  use_frameworks!
  
  module_pod
  pod 'RxSwift', '~> 6.0'
  pod 'Kingfisher', '~> 7.0'
  pod 'Nantes', '~> 0.0'
  pod 'Alamofire', '~> 5.0'
end
