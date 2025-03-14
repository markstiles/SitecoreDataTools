# SitecoreDataTools

## Environment Setup

### Install Python
* use Conda
* https://docs.conda.io/projects/conda/en/stable/user-guide/install/windows.html

### Create Virtual Environment
* use Anaconda Navigator
* https://www.edlitera.com/blog/posts/manage-virtual-environments-anaconda#:~:text=To create an environment
* https://www.anaconda.com/docs/tools/working-with-conda/environments    

### Install VS Code Plugins
* Power User for dbt
* Data Wrangler
* Jupyter
* Jupyter Cell Tags
* Jupyter Notebook Renderers
* Python
* Python Debugger
* Pylance

### Use Python's package manager, pip, to install packages (with Terminal in VS Code)
* pypyodbc
* scipy
* pandas
* pyyaml
* matplotlib
* seaborn
* joypy
* folium
* sqlalchemy
* pyyaml
* dbt.core
* dbt-sqlserver

### Install dbt (with Terminal in VS Code)
* dbt manages all the SQL in a project format that's required to convert raw data into business recognizeable data structures
* https://docs.getdbt.com/docs/core/pip-install

### Setup dbt Profile
* dbt needs database connection information but doesn't store it locally
* copy and rename the sample-profiles to C:\Users\<username>\.dbt\profiles.yml
* populate the profile database connection values with your settings

### Run Loading Script
* the first step in creating useable analytics is migrating them to one single database
* the loading scripts merge both xDB shard data and content into one database
* open the OnPremLoading.ipynb file and start executing the cells
* the list of scripts can be run in chunks or one-at-a-time
* you can modify the scripts or migrate them to 3rd party extract/load tools like Azure Data Factory or FiveTran

### Run dbt 
* this compiles the SQL and will create a hierarchy of views and tables from your raw data in your warehouse database
* open the terminal, browse to the 'Transform' folder and run the command 'dbt run'

### Run Mining Scripts
* use the new tables dbt creates to inspect data and build visualizations
* open the Mining.ipynb file and start executing the cells

### Connect your BI tools
* you can also inspect data and build reports with common BI tools:
    * Power BI
    * Tableau
    * Looker
    * Metabase 
    * Apache Superset