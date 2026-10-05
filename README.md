# SFDX Project Template
Now that you’ve created a Salesforce DX project, what’s next? 

## Configure Your Salesforce DX Project
The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

### Configure this repo:
* Update <code>sfdx-project.json</code> to include metadata appropriate to your package.
* Enable any necessary Salesforce extensions in VSCode, especially the Salesforce Extension Pack.
* Identify the lifecycle commands used to create, version, release and install the package.
* Create the package, update some code, create a package version and release a package for installation to a production environment.

### Update <code>sfdx-project.json</code>.

### Create the package.
```bash
sf package create --name "My Package" --package-type Unlocked --path sfdx-source/Modules/default --org-dependent
```

### Create the package version
```bash
sf package version create --package "My Package" --code-coverage --installation-key-bypass --wait 30
```

### Release a package version
```bash
sf package version promote --package "My Package@0.1.0-1"
```

## Additional considerations
Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).


## Read all about it
* [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
* [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
* [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
* [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
