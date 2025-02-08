# makefiles/utils.mk:

# 通用函数，用于根据相对路径或绝对路径生成绝对路径
# 定义 DOCKER_DATA_PATH
DOCKER_DATA_PATH = /docker-data

# 改进的 get_absolute_path 函数
get_absolute_path = $(strip \
    $(if $(filter /%,$(1)), \
        $(1), \
        $(if $(filter ./%,$(1)), \
            $(PROJECT_DIR)/$(patsubst ./%,%,$(1)), \
            $(PROJECT_DIR)/$(1) \
        ) \
    ) \
)

# 测试用例
test.get_absolute_path:
	@echo $(call get_absolute_path,/absolute/path)       # 输出: /absolute/path
	@echo $(call get_absolute_path,data/xxx)             # 输出: /docker-data/data/xxx
	@echo $(call get_absolute_path,./data/xxx)           # 输出: /docker-data/data/xxx
	@echo $(call get_absolute_path,relative/path)        # 输出: /docker-data/relative/path
