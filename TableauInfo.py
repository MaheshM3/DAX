import zipfile
from tableau_tools.tableau_documents import *

# Load the TWBX file
twbx_file = 'your_file.twbx'
zip_file = zipfile.ZipFile(twbx_file, 'r')

# Extract the TWB file from the TWBX file
twb_file = None
for file in zip_file.namelist():
    if file.endswith('.twb'):
        zip_file.extract(file)
        twb_file = file
        break

if twb_file is None:
    print("No .twb file found in the .twbx file.")
else:
    # Load the workbook from the TWB file
    workbook = Workbook(twb_file)

    if workbook is None:
        print("Failed to create Workbook object.")
    else:
        # Iterate over all dashboards in the workbook
        for dashboard in workbook.dashboards:
            print(f'Dashboard name: {dashboard.name}')

            # Iterate over all worksheets in the workbook
            for worksheet in workbook.worksheets:
                # Check if the worksheet is in the current dashboard
                if worksheet.name in dashboard.worksheets:
                    print(f'Worksheet name: {worksheet.name}')
