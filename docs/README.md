# LibTemplatePlaceholder

Welcome to **LibTemplatePlaceholder**. This repository serves as a template to create repositories used to build iOS libraries. This file will guide you through that process, that is defined by two sequential steps:

1. Use the current repository as the template for the new one.
2. Clone the new repository on our machine.
3. Run a script that updates the created repository with the correct information.

These steps are detailed in the next sections.

:warning: Every step listed here must be successfully completed before you start working on the new repository.

## Create a Repository Based on the Template

First, we need to create a new repository. To accomplish this, please press the **Use this template** button available on the repository's GitHub webpage.

![Use this template button](./assets/useThisTemplateButton.png)

Next, we have to define the new repository's name. In order to get the maximum performance of the following step, we advise you to use the **[ProjectName]Lib-iOS** format for the name. The names used for the **Health and Fitness** and the **Social Logins** are valid examples of the expected format (_OSHealthFitnessLib-iOS_ and _OSSocialLoginsLib-iOS_ respectively).

The following image shows an example of the creation of a repository for the iOS' Payments Library.

![Example for payments repository name](./assets/repositoryNameExample.png)

After filling up the form as needed, the last step to effectively create the repository is the click on the **Create repository from template** button.

![Create repository from template button](./assets/createRepositoryButton.png)

## Clone the New Repository

After completing the previous step, the next one is something common done in every repository a developer needs to do work on: clone the repository on the local machine.

## Run the **generator_script.sh**

To finish the process, we just have one last thing to do. Run the **generator_script.sh** script that automates a couple of changes we need to apply. It is included in the _scripts_ folder.

To run the script, please execute the following commands on **Terminal**:

```
cd scripts
sh generator_script.sh
```

Here's the complete list of what the script does:

- The script provides a bit of information, such as mentioning the name that it will use as the Library name (its based on the one you used while creating the repository on GitHub).
- Requests the user for the application's organisational identifier. The format required is provided and needs to be complied with in order to advance.
- It informs that the script itself will be deleted, as it is a one time execution only.
- It performs the needed changes, replacing all placeholder's organisational identifier and library name for the ones provided by the user.
- To conclude, the script commits and pushes the changes to the remote repository.
