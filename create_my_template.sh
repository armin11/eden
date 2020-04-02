#!/bin/bash
# 
#subtemplate from default
#path of web2py: /home/web2py/
#path of eden: /home/web2py/applications/eden
#path of templates: 
# =============================================================================
# 
#

web2py_home="/home/web2py/"
web2py_user="web2py"
eden_app_name="eden"
logo_url="https://www.rlp.de/fileadmin/_processed_/7/b/csm_Wappen_breit_7f5cb8ce59.jpg"
echo -e "What should be the name of my template? [my_template] : \c "
read MYTEMPLATE
if [[ ! "$MYTEMPLATE" ]]; then
    MYTEMPLATE="covid-19"
fi
echo -e "What should the blueprint template? [default] : \c "
read BLUEPRINTTEMPLATE
if [[ ! "$BLUEPRINTTEMPLATE" ]]; then
    BLUEPRINTTEMPLATE="default"
fi

#delete old template relicts
rm -r ${web2py_home}applications/${eden_app_name}/modules/templates/${MYTEMPLATE}
rm -r ${web2py_home}applications/${eden_app_name}/static/themes/${MYTEMPLATE}

mkdir ${web2py_home}applications/${eden_app_name}/modules/templates/${MYTEMPLATE}
#copy skeleton - really needed?
cp -r ${web2py_home}applications/${eden_app_name}/modules/templates/skeleton/* ${web2py_home}applications/${eden_app_name}/modules/templates/${MYTEMPLATE}/


#create static folder with simple style.css in
mkdir ${web2py_home}applications/${eden_app_name}/static/themes/$MYTEMPLATE
cat << EOF > "${web2py_home}applications/${eden_app_name}/static/themes/$MYTEMPLATE/style.css"
#login_form {
  display:none;
}
#about {
  display:none;
}
#feed-control {
  display:none;
}
EOF
#copy skeletontheme css file 
cp ${web2py_home}applications/${eden_app_name}/modules/templates/skeletontheme/css.cfg ${web2py_home}applications/${eden_app_name}/modules/templates/${MYTEMPLATE}/
#alter css.cfg - add 
#delete last line - required for parsing
sed -i '$ d' ${web2py_home}applications/${eden_app_name}/modules/templates/${MYTEMPLATE}/css.cfg
echo "../themes/${MYTEMPLATE}/style.css" >> ${web2py_home}applications/${eden_app_name}/modules/templates/${MYTEMPLATE}/css.cfg
echo "# Final line required for parsing" >> ${web2py_home}applications/${eden_app_name}/modules/templates/${MYTEMPLATE}/css.cfg

#copy the layout.html file from blueprint template
cp ${web2py_home}applications/${eden_app_name}/modules/templates/${BLUEPRINTTEMPLATE}/views/layout.html ${web2py_home}applications/${eden_app_name}/modules/templates/${MYTEMPLATE}/views/
cp ${web2py_home}applications/${eden_app_name}/modules/templates/${BLUEPRINTTEMPLATE}/views/footer.html ${web2py_home}applications/${eden_app_name}/modules/templates/${MYTEMPLATE}/views/

#create config file
cat << EOF > "${web2py_home}applications/${eden_app_name}/modules/templates/$MYTEMPLATE/config.py"
# -*- coding: utf-8 -*-

from collections import OrderedDict

from gluon import current
from gluon.storage import Storage

def config(settings):
    from templates.${BLUEPRINTTEMPLATE}.config import config as OTHER_config

    OTHER_config(settings)

    T = current.T

    settings.base.system_name = T("Demo: Krisenmanagementplattform")
    settings.base.system_name_short = T("Demo: Krisenmanagementplattform")
    #delete definitions from default template for initial imports
    del settings.base.prepopulate[:]
    settings.base.prepopulate.append("$MYTEMPLATE")
    settings.base.theme = "$MYTEMPLATE"
    settings.L10n.languages = OrderedDict([
        ("en", "English"),
        ("fr", "French"),
        ("de", "German"),
        ("it", "Italian"),
    ])
    # Default language for Language Toolbar (& GIS Locations in future)
    settings.L10n.default_language = "de" 
    settings.L10n.decimal_separator = ","
    settings.L10n.translate_gis_layer = True
    settings.L10n.translate_gis_location = False
    settings.L10n.name_alt_gis_location = True
    settings.fin.currency_default = "EUR"
    settings.ui.social_buttons = True
    #settings.ui.menu_logo = "/%s/static/themes/$MYTEMPLATE/img/logo.jpg" % current.request.application
    settings.modules = OrderedDict([
        # Core modules which shouldn't be disabled
        ("default", Storage(
            name_nice = T("Default"),
            restricted = False, # Use ACLs to control access to this module
            module_type = None  # This item is not shown in the menu
        )),
        ("admin", Storage(
            name_nice = T("Administration"),
            #description = "Site Administration",
            access = "|1|",     # Only Administrators can see this module in the default menu & access the controller
            module_type = None  # This item is handled separately for the menu
        )),
        ("appadmin", Storage(
            name_nice = T("Administration"),
            #description = "Site Administration",
            module_type = None  # No Menu
        )),
        ("errors", Storage(
            name_nice = T("Ticket Viewer"),
            #description = "Needed for Breadcrumbs",
            restricted = False,
            module_type = None  # No Menu
        )),
        ("setup", Storage(
            name_nice = T("Setup"),
            #description = "WebSetup",
            access = "|1|",     # Only Administrators can see this module in the default menu & access the controller
            module_type = None  # No Menu
        )),
        ("sync", Storage(
            name_nice = T("Synchronization"),
            #description = "Synchronization",
            access = "|1|",     # Only Administrators can see this module in the default menu & access the controller
            module_type = None  # This item is handled separately for the menu
        )),
        #("tour", Storage(
        #    name_nice = T("Guided Tour Functionality"),
        #    module_type = None,
        #)),
        ("translate", Storage(
            name_nice = T("Translation"),
            #description = "Selective translation of strings based on module.",
            module_type = None,
        )),
        ("gis", Storage(
            name_nice = T("Map"),
            #description = "Situation Awareness & Geospatial Analysis",
            module_type = 6,     # 6th item in the menu
        )),
        ("pr", Storage(
            name_nice = T("Person Registry"),
            #description = "Central point to record details on People",
            access = "|1|",     # Only Administrators can see this module in the default menu (access to controller is possible to all still)
            module_type = 10
        )),
        ("org", Storage(
            name_nice = T("Organizations"),
            #description = 'Lists "who is doing what & where". Allows relief agencies to coordinate their activities',
            module_type = 1
        )),
        # All modules below here should be possible to disable safely
        ("hrm", Storage(
            name_nice = T("Staff"),
            #description = "Human Resources Management",
            module_type = 2,
        )),
        ("vol", Storage(
            name_nice = T("Volunteers"),
            #description = "Human Resources Management",
            module_type = 2,
        )),
        #("cms", Storage(
        #    name_nice = T("Content Management"),
            #description = "Content Management System",
        #    module_type = 10,
        #)),
        ("doc", Storage(
            name_nice = T("Documents"),
            #description = "A library of digital resources, such as photos, documents and reports",
            module_type = 10,
        )),
        ("msg", Storage(
            name_nice = T("Messaging"),
            #description = "Sends & Receives Alerts via Email & SMS",
            # The user-visible functionality of this module isn't normally required. Rather it's main purpose is to be accessed from other modules.
            module_type = None,
        )),
        ("supply", Storage(
            name_nice = T("Supply Chain Management"),
            #description = "Used within Inventory Management, Request Management and Asset Management",
            module_type = None, # Not displayed
        )),
        #("inv", Storage(
        #    name_nice = T("Warehouses"),
            #description = "Receiving and Sending Items",
        #    module_type = 4
        #)),
        #("proc", Storage(
        #    name_nice = T("Procurement"),
        #    #description = "Ordering & Purchasing of Goods & Services",
        #    module_type = 10
        #)),
        #("asset", Storage(
        #    name_nice = T("Assets"),
            #description = "Recording and Assigning Assets",
        #    module_type = 5,
        #)),
        # Vehicle depends on Assets
        #("vehicle", Storage(
        #    name_nice = T("Vehicles"),
            #description = "Manage Vehicles",
        #    module_type = 10,
        #)),
        ("req", Storage(
            name_nice = T("Requests"),
            #description = "Manage requests for supplies, assets, staff or other resources. Matches against Inventories where supplies are requested.",
            module_type = 10,
        )),
        #("project", Storage(
        #    name_nice = T("Projects"),
            #description = "Tracking of Projects, Activities and Tasks",
        #    module_type = 2
        #)),
        ("stats", Storage(
            name_nice = T("Statistics"),
            #description = "Manages statistics",
            module_type = None,
        )),
        #("event", Storage(
        #    name_nice = T("Events"),
        #    #description = "Activate Events (e.g. from Scenario templates) for allocation of appropriate Resources (Human, Assets & Facilities).",
        #    module_type = 10,
        #)),
        #("br", Storage(
        #    name_nice = T("Beneficiary Registry"),
        #    #description = "Allow affected individuals & households to register to receive compensation and distributions",
        #    module_type = 10,
        #)),
        #("cr", Storage(
        #    name_nice = T("Shelters"),
        #    #description = "Tracks the location, capacity and breakdown of victims in Shelters",
        #    module_type = 10
        #)),
        #("dc", Storage(
        #   name_nice = T("Assessments"),
        #   #description = "Data collection tool",
        #   module_type = 5
        #)),
        ("hms", Storage(
            name_nice = T("Hospitals"),
            #description = "Helps to monitor status of hospitals",
            module_type = 10
        )),
        #("member", Storage(
        #    name_nice = T("Members"),
        #    #description = "Membership Management System",
        #    module_type = 10,
        #)),
        #("budget", Storage(
        #    name_nice = T("Budgeting Module"),
        #    #description = "Allows a Budget to be drawn up",
        #    module_type = 10
        #)),
        #("deploy", Storage(
        #    name_nice = T("Deployments"),
        #    #description = "Manage Deployments",
        #    module_type = 10,
        #)),
        ("disease", Storage(
            name_nice = T("Disease Tracking"),
            #description = "Helps to track cases and trace contacts in disease outbreaks",
            module_type = 10
        )),
        #("edu", Storage(
        #    name_nice = T("Schools"),
        #    #description = "Helps to monitor status of schools",
        #    module_type = 10
        #)),
        #("fire", Storage(
        #   name_nice = T("Fire Stations"),
        #   #description = "Fire Station Management",
        #   module_type = 1,
        #)),
        #("transport", Storage(
        #    name_nice = T("Transport"),
        #    module_type = 10,
        #)),
        #("water", Storage(
        #    name_nice = T("Water"),
        #    #description = "Flood Gauges show water levels in various parts of the country",
        #    module_type = 10
        #)),
        #("patient", Storage(
        #    name_nice = T("Patient Tracking"),
        #    #description = "Tracking of Patients",
        #    module_type = 10
        #)),
        #("po", Storage(
        #    name_nice = T("Population Outreach"),
        #    #description = "Population Outreach",
        #    module_type = 10
        #)),
        #("security", Storage(
        #   name_nice = T("Security"),
        #   #description = "Security Management System",
        #   module_type = 10,
        #)),
        #("vulnerability", Storage(
        #    name_nice = T("Vulnerability"),
        #    #description = "Manages vulnerability indicators",
        #    module_type = 10,
        # )),
        #("work", Storage(
        #   name_nice = T("Jobs"),
        #   #description = "Simple Volunteer Jobs Management",
        #   restricted = False,
        #   module_type = None,
        #)),
        # Deprecated: Replaced by BR
        #("dvr", Storage(
        #    name_nice = T("Beneficiary Registry"),
        #    #description = "Disaster Victim Registry",
        #    module_type = 10
        #)),
        # Deprecated: Replaced by event
        #("irs", Storage(
        #    name_nice = T("Incidents"),
        #    #description = "Incident Reporting System",
        #    module_type = 10
        #)),
        # Deprecated: Replaced by DC
        #("survey", Storage(
        #    name_nice = T("Surveys"),
        #    #description = "Create, enter, and manage surveys.",
        #    module_type = 5,
        #)),
        # These are specialist modules
        #("cap", Storage(
        #    name_nice = T("CAP"),
        #    #description = "Create & broadcast CAP alerts",
        #    module_type = 10,
        #)),
        #("dvi", Storage(
        #   name_nice = T("Disaster Victim Identification"),
        #   #description = "Disaster Victim Identification",
        #   module_type = 10,
        #   #access = "|DVI|",      # Only users with the DVI role can see this module in the default menu & access the controller
        #)),
        #("mpr", Storage(
        #   name_nice = T("Missing Person Registry"),
        #   #description = "Helps to report and search for missing persons",
        #   module_type = 10,
        #)),
        # Requires RPy2 & PostgreSQL
        #("climate", Storage(
        #    name_nice = T("Climate"),
        #    #description = "Climate data portal",
        #    module_type = 10,
        #)),
        #("delphi", Storage(
        #    name_nice = T("Delphi Decision Maker"),
        #    #description = "Supports the decision making of large groups of Crisis Management Experts by helping the groups create ranked list.",
        #    restricted = False,
        #    module_type = 10,
        #)),
        # @ToDo: Port these Assessments to the Survey module
        #("building", Storage(
        #    name_nice = T("Building Assessments"),
        #    #description = "Building Safety Assessments",
        #    module_type = 10,
        #)),
        # Deprecated by Surveys module
        # - depends on CR, IRS & Impact
        #("assess", Storage(
        #    name_nice = T("Assessments"),
        #    #description = "Rapid Assessments & Flexible Impact Assessments",
        #    module_type = 10,
        #)),
        #("impact", Storage(
        #    name_nice = T("Impacts"),
        #    #description = "Used by Assess",
        #    module_type = None,
        #)),
        #("ocr", Storage(
        #   name_nice = T("Optical Character Recognition"),
        #   #description = "Optical Character Recognition for reading the scanned handwritten paper forms.",
        #   restricted = False,
        #   module_type = None,
        #)),
    ])
EOF

#create menu file
cat << EOF > "${web2py_home}applications/${eden_app_name}/modules/templates/$MYTEMPLATE/menu.py"
from templates.${BLUEPRINTTEMPLATE}.menus import S3OptionsMenu as OTHEROptionsMenu
    class S3OptionsMenu(OTHEROptionsMenu):
    # Override those side menus which are specific.
    
EOF

#create controller file
cat << EOF > "${web2py_home}applications/${eden_app_name}/modules/templates/$MYTEMPLATE/controllers.py"
# Pull a page from another template
from templates.${BLUEPRINTTEMPLATE}.controllers import other_page
# (This could be subclassed if-desired)
# Define your own homepage:
class index():
    def __call__():
        return other_class()()
    
EOF
#copy foundation folder from blueprint template
cp -r ${web2py_home}applications/${eden_app_name}/static/themes/$BLUEPRINTTEMPLATE/foundation ${web2py_home}applications/${eden_app_name}/static/themes/$MYTEMPLATE/
#pull logo from source
mkdir ${web2py_home}applications/${eden_app_name}/static/themes/$MYTEMPLATE/img
cd ${web2py_home}applications/${eden_app_name}/static/themes/$MYTEMPLATE/img
wget -O logo.jpg $logo_url
#back to web2py working dir
cd ${web2py_home}
#delete compiled folder? - problem because root was owner! 
rm -r ${web2py_home}applications/${eden_app_name}/compiled
#compile css
#sudo -H -u web2py python web2py.py -S eden -M -R applications/eden/static/scripts/tools/build.sahana.py
python web2py.py -S eden -M -R applications/eden/static/scripts/tools/build.sahana.py
#delete compiled folder? - problem because root was owner! 
#chown of compiled folder to web2py
chown -R web2py ${web2py_home}applications/${eden_app_name}/compiled
#rm -r ${web2py_home}applications/${eden_app_name}/compiled
