from tableau_tools.tableau_documents import *

# Load the TWBX file
twbx_file = 'your_file.twbx'
twb_file = extract_twbx(twbx_file)

# Load the workbook from the TWB file
workbook = Workbook(twb_file)

# Iterate over all dashboards in the workbook
for dashboard in workbook.dashboards:
    print(f'Dashboard name: {dashboard.name}')

    # Iterate over all worksheets in the current dashboard
    for worksheet in dashboard.worksheets:
        print(f'Worksheet name: {worksheet.name}')
