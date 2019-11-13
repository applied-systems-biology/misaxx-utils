echo "MISA++ Project Creation Helper"
echo "------------------------------"
echo ""
echo "This tool will create a valid MISA++ CMake project in the specified folder"
echo ""

function read_user_input($prompt, $defaultv) {
  $value = Read-Host "$prompt [$defaultv]"
  if($value) {
    return $value
  }
  return $defaultv
}

$PROJECT_DIR = read_user_input -prompt "Enter project directory" -defaultv $pwd
$MODULE_NAME = read_user_input -prompt "Enter module library name" -defaultv "my-module"
$MODULE_CXX_NAME = read_user_input -prompt "Enter module C++ name" -defaultv "my_module"
$MODULE_VERSION = read_user_input -prompt "Enter module version" -defaultv "1.0.0"
$MODULE_DESCRIPTION = Read-Host "Enter an optional short description"

echo ""
echo "All required settings have been made. All following settings are details like C++ namespaces."
echo "Feel free to accept all default values."
echo ""

$MODULE_NAMESPACE = read_user_input -prompt "Enter module C++ namespace" -defaultv $MODULE_CXX_NAME
$MODULE_API_NAME = read_user_input -prompt "Enter module C++ API name" -defaultv $MODULE_CXX_NAME
$MODULE_API_NAMESPACE = read_user_input -prompt "Enter module C++ API namespace" -defaultv $MODULE_CXX_NAME
$MODULE_API_INCLUDE_PATH = read_user_input -prompt "Enter module C++ API include path" -defaultv $MODULE_NAME

echo ""
echo "Configuration done."
echo ""
echo "Summary"
echo "-------"
echo ""
echo "Project directory: $PROJECT_DIR"
echo "Module/project name: $MODULE_NAME"
echo "Module/project name in C++: $MODULE_CXX_NAME"
echo "Project version: $MODULE_VERSION"
echo "Description: $MODULE_DESCRIPTION"
echo ""
echo "Module namespace: $MODULE_NAMESPACE"
echo "C++ API name: $MODULE_API_NAME"
echo "C++ API namespace: $MODULE_API_NAMESPACE"
echo "C++ API include path $MODULE_API_INCLUDE_PATH"
echo ""
echo ""

Read-Host "Press enter if those settings are OK"

mkdir -p $PROJECT_DIR
Push-Location $PROJECT_DIR
mkdir -p ./include/$MODULE_API_INCLUDE_PATH/
mkdir -p ./src/$MODULE_API_INCLUDE_PATH/

@"
cmake_minimum_required(VERSION 3.11) # Or higher if required
project($MODULE_NAME VERSION $MODULE_VERSION DESCRIPTION "$MODULE_DESCRIPTION")

find_package(misaxx-core REQUIRED)
# Add additional packages if necessary

add_library($MODULE_NAME include/$MODULE_API_INCLUDE_PATH/module_interface.h
                include/$MODULE_API_INCLUDE_PATH/module.h
                src/$MODULE_API_INCLUDE_PATH/module_interface.cpp
                src/$MODULE_API_INCLUDE_PATH/module.cpp
                src/$MODULE_API_INCLUDE_PATH/module_info.cpp)

# Add additional link targets if necessary
target_link_libraries($MODULE_NAME misaxx::misaxx-core)

# MISA++ helper script (automatically included by Core Library)
set(MISAXX_LIBRARY $MODULE_NAME)
set(MISAXX_LIBRARY_NAMESPACE $MODULE_NAMESPACE::)
set(MISAXX_API_NAME $MODULE_API_NAME)
set(MISAXX_API_INCLUDE_PATH $MODULE_API_INCLUDE_PATH)
set(MISAXX_API_NAMESPACE $MODULE_API_NAMESPACE)
misaxx_with_default_module_info()
misaxx_with_default_api()

# Only if it's a worker module:
misaxx_with_default_executable()
"@ | Out-File ./CMakeLists.txt

@"
#include <misaxx/core/misa_module_interface.h>

namespace $MODULE_NAMESPACE {
    struct module_interface : public misaxx::misa_module_interface {
        void setup() override;
    };
}
"@ | Out-File ./include/$MODULE_API_INCLUDE_PATH/module_interface.h

@"
#include <misaxx/core/misa_module.h>
#include <$MODULE_API_INCLUDE_PATH/module_interface.h>

namespace $MODULE_NAMESPACE {
    struct module : public misaxx::misa_module<module_interface> {
        using misaxx::misa_module<module_interface>::misa_module;

        void create_blueprints(blueprint_list &t_blueprints, parameter_list &t_parameters) override;
        void build(const blueprint_builder &t_builder) override;
    };
}
"@ | Out-File ./include/$MODULE_API_INCLUDE_PATH/module.h

@"
#include <misaxx/core/misa_module_interface.h>
#include <$MODULE_API_INCLUDE_PATH/module_interface.h>

using namespace $MODULE_NAMESPACE;

void module_interface::setup() {
    // Initialize data and submodules here
}
"@ | Out-File ./src/$MODULE_API_INCLUDE_PATH/module_interface.cpp

@"
#include <misaxx/core/misa_module.h>
#include <$MODULE_API_INCLUDE_PATH/module.h>

using namespace $MODULE_NAMESPACE;

void module::create_blueprints(blueprint_list &t_blueprints, parameter_list &t_parameters) {
    // Declare tasks and sub-dispatchers here
}

void module::build(const blueprint_builder &t_builder) {
    // Instantiate tasks and sub-dispatchers here
}
"@ | Out-File ./src/$MODULE_API_INCLUDE_PATH/module.cpp

@"
#include <misaxx/core/module_info.h>
#include <$MODULE_API_INCLUDE_PATH/module_info.h>

misaxx::misa_module_info $MODULE_NAMESPACE::module_info() {
    misaxx::misa_module_info info;
    info.set_id("$MODULE_NAME");
    info.set_version("$MODULE_VERSION");
    info.set_name("$MODULE_NAME");
    info.set_description("$MODULE_DESCRIPTION");

    info.add_dependency(misaxx::module_info());
    // TODO: Add dependencies via info.add_dependency()
    return info;
}
"@ | Out-File ./src/$MODULE_API_INCLUDE_PATH/module_info.cpp

Pop-Location
