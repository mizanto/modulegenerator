PROJECT_NAME = "TestProject"
AUTHOR = "Sergey Bendak"
COMPANY = "Home"
TEMPLATES_FOLDER = "templates"
RESULTS_FOLDER = "results"
MODULE_NAME = "Test"

####### don't change code below #########

# component types
TYPE_MODULE = "Module"
TYPE_VIEW_CONTROLLER = "ViewController"
TYPE_LOGIC = "Logic"
TYPE_VIEW_INPUT = "ViewInput"
TYPE_VIEW_OUTPUT = "ViewOutput"


def header(name = "_____", created = "_created_")
  file_name = file_name_from_class(name)
  header_template = IO.read(path_for_template("header")) % {
    :file_name => file_name,
    :project_name => PROJECT_NAME,
    :author => AUTHOR,
    :created => created,
    :company => COMPANY
  }
  header_template += "\n"
end

def module_content(name)
  module_name = name + "Module"
  code = IO.read(path_for_template("module")) % {
    :view_controller_name => name + "ViewController",
    :module_name => module_name,
    :logic_name => name + "Logic"
  }
  module_template = header(module_name) + code
end

def view_controller_content(name)
  view_controller_name = name + "ViewController"
  code = IO.read(path_for_template("view_controller")) % {
    :view_controller_name => view_controller_name,
    :view_input_name => name + "ViewInput",
    :veiw_output_name => name + "ViewOutput"
  }
  view_controller_template = header(view_controller_name) + code
end

def logic_content(name)
  logic_name = name + "Logic"
  code = IO.read(path_for_template("logic")) % {
    :logic_name => logic_name,
    :veiw_output_name => name + "ViewOutput",
    :view_input_name => name + "ViewInput",
    :module_name => name + "Module"
  }

  logic_template = header(logic_name) + code
end

def view_input_content(name)
  view_input_name = name + "ViewInput"

  code = IO.read(path_for_template("view_input")) % {
    :view_input_name => view_input_name
  }

  view_input_template = header(view_input_name) + code
end

def view_output_content(name)
  view_output_name = name + "ViewOutput"

  code = IO.read(path_for_template("view_output")) % {
    :view_output_name => view_output_name
  }

  view_output_template = header(view_output_name) + code
end

def file_name_from_class(name)
  return name + ".swift"
end

def path_for_template(template_name)
  return "#{TEMPLATES_FOLDER}/#{template_name}.template"
end

def path_for_result(name)
  return "#{RESULTS_FOLDER}/#{MODULE_NAME}/#{file_name_from_class(name)}"
end

def setup_folders
  Dir.mkdir(RESULTS_FOLDER) unless Dir.exist?(RESULTS_FOLDER)
  current_module_folder = RESULTS_FOLDER + "/" + MODULE_NAME
  Dir.mkdir(current_module_folder) unless Dir.exist?(current_module_folder)
end

def generate_module(name, path = "")
  setup_folders()

  create_component(name, TYPE_MODULE)
  create_component(name, TYPE_VIEW_CONTROLLER)
  create_component(name, TYPE_LOGIC)
  create_component(name, TYPE_VIEW_INPUT)
  create_component(name, TYPE_VIEW_OUTPUT)
  puts "succsses!"
end

# types:
# TYPE_MODULE, TYPE_VIEW_CONTROLLER, TYPE_LOGIC, TYPE_VIEW_INPUT, TYPE_VIEW_OUTPUT
def create_component(name, type)
  template = "...ERROR..."
  if type == TYPE_MODULE
    template = module_content(name)
  elsif type == TYPE_VIEW_CONTROLLER
    template = view_controller_content(name)
  elsif type == TYPE_LOGIC
    template = logic_content(name)
  elsif type == TYPE_VIEW_INPUT
    template = view_input_content(name)
  elsif type == TYPE_VIEW_OUTPUT
    template = view_output_content(name)
  else
    raise "Error: Unknown type (#{type})!"
  end

  File.open(path_for_result(name + type), "w+") { |f| f.write(template) }
end

generate_module(MODULE_NAME)
