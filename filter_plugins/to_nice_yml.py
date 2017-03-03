# import from the latest ansible tree

from ansible import errors
from ansible.parsing.yaml.dumper import AnsibleDumper
from ansible.parsing.yaml.objects import AnsibleUnicode
from ansible.vars.unsafe_proxy import AnsibleUnsafeText
import yaml

represent_unicode = yaml.representer.SafeRepresenter.represent_unicode

AnsibleDumper.add_representer(
    AnsibleUnsafeText,
    represent_unicode,
)

def to_nice_yaml(a, indent=4, *args, **kw):
    '''Make verbose, human readable yaml'''
    transformed = yaml.dump(a, Dumper=AnsibleDumper, indent=indent, allow_unicode=True, default_flow_style=False, **kw)
    return transformed
class FilterModule(object):
    def filters(self):
        return {
                'to_nice_yaml' : to_nice_yaml,
                }
