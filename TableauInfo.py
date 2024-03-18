import zipfile
from tableau_tools.tableau_documents import *

# Load the TWBX file
twbx_file = 'your_file.twbx'
zip_file = zipfile.ZipFile(twbx_file, 'r')

# Extract the TWB file from the TWBX file
for file in zip_file.namelist():
    if file.endswith('.twb'):
        zip_file.extract(file)
        twb_file = file
        break

# Load the workbook from the TWB file
workbook = Workbook(twb_file)

# Iterate over all dashboards in the workbook
for dashboard in workbook.dashboards:
    print(f'Dashboard name: {dashboard.name}')

    # Iterate over all worksheets in the current dashboard
    for worksheet in dashboard.worksheets:
        print(f'Worksheet name: {worksheet.name}')
