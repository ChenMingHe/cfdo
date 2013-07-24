require 'rubygems'
require 'json'

require File.expand_path("./vcap_common.rb", File.dirname(__FILE__))

# 系统的环境配置参数
# 默认配置文件
DEPLOYMENT_DEFAULT_SPEC = File.join("deployments", "devbox.yml")
# 默认部署名称
DEPLOYMENT_DEFAULT_NAME = "devbox"
# 默认使用域名
DEPLOYMENT_DEFAULT_DOMAIN = "vcap.me"
# 默认配置文件所在目录名称
DEPLOYMENT_CONFIG_DIR_NAME = "config"
# 默认配置组件名称,Chef在初始化后会生成这里的配置文件
DEPLOYMENT_CONFIG_FILE_NAME = "deploy.json"
# 默认启动组件配置
DEPLOYMENT_VCAP_CONFIG_FILE_NAME = "vcap_components.json"
# 部署信息文件
DEPLOYMENT_INFO_FILE_NAME = "deployment_info.json"
# 部署目标配置
DEPLOYMENT_TARGET_FILE_NAME = File.expand_path(File.join(ENV["HOME"], ".cloudfoundry_deployment_target"))
# 环境变量配置
DEPLOYMENT_PROFILE_FILE_NAME = File.expand_path(File.join(ENV["HOME"], ".cloudfoundry_deployment_profile"))
# 
DEPLOYMENT_LOCAL_RUN_PROFILE_FILE_NAME = File.expand_path(File.join(ENV["HOME"], ".cloudfoundry_deployment_local"))

class Deployment
  class << self # 指明为一个单态类
    # 获取Cloud Foundry的安装目录 
    def get_cloudfoundry_home
      File.expand_path(File.join(ENV["HOME"], "cloudfoundry"))
    end

    def get_cloudfoundry_domain
      DEPLOYMENT_DEFAULT_DOMAIN
    end

    # 获取部署配置文件所在路径
    def get_config_path(name, cloudfoundry_home=nil)
      cloudfoundry_home ||= get_cloudfoundry_home
      File.expand_path(File.join(cloudfoundry_home, ".deployments", name, DEPLOYMENT_CONFIG_DIR_NAME))
    end

    # 获取部署配置文件名
    def get_config_file(config_path)
      File.expand_path(File.join(config_path, DEPLOYMENT_CONFIG_FILE_NAME))
    end

    # 启动时候的配置文件名称
    def get_vcap_config_file(config_path)
      File.expand_path(File.join(config_path, DEPLOYMENT_VCAP_CONFIG_FILE_NAME))
    end

    # 提供部署信息文件名称
    def get_deployment_info_file(config_path)
      File.expand_path(File.join(config_path, DEPLOYMENT_INFO_FILE_NAME))
    end

    def get_deployment_profile_file
      DEPLOYMENT_PROFILE_FILE_NAME
    end

    def get_local_deployment_run_profile
      DEPLOYMENT_LOCAL_RUN_PROFILE_FILE_NAME
    end

    def save_deployment_target(deployment_name, cloudfoundry_home)
      File.open(DEPLOYMENT_TARGET_FILE_NAME, "w") do |file|
        file.puts({"deployment_name" => deployment_name, "cloudfoundry_home" => cloudfoundry_home}.to_json)
      end
    end

    def get_deployment_target
      begin 
        info = JSON.parse(File.read(DEPLOYMENT_TARGET_FILE_NAME))
        [ info["deployment_name"], info["cloudfoundry_home"] ]
      rescue => e
      end
    end
  end
end
