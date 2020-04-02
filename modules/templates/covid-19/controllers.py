# Pull a page from another template
from templates.default.controllers import other_page
# (This could be subclassed if-desired)
# Define your own homepage:
class index():
    def __call__():
        return other_class()()
    
