
import json
import os
import subprocess


class ParseResult:
    def __init__(self, markdown_path):
        dir_name = os.path.dirname(os.path.realpath(__file__))
        parse_result_from_node = subprocess.check_output(['node', dir_name + '/WrapParser.js', os.path.abspath(markdown_path)])
        self.json = json.loads(str(parse_result_from_node, 'utf-8'))
    
    def is_config_defined(self, key):
        return key in self.json['config'].keys()

    def get_config(self, key):
        if self.is_config_defined(key):
            return self.json['config'][key]
        else:
            print("Warning: Key " + key + " is not defined on the parse result")
            return ""
    
    def get_content(self):
        return "".join(self.json['body'])