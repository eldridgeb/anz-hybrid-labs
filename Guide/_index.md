# Azure Arc-enabled servers LevelUp Training

## Goals

The purpose of this workshop is to help people learn Azure Arc-enabled server concepts, features, value proposition, and do hands on training to help customers deploy Azure Arc-enabled servers.

After completion of this workshop, you will be able to:

- Understand pre-requisites to onboard Windows and Linux servers to Azure Arc
- Onboard Windows and Linux servers running using different onboarding methods
- Monitor your Azure Arc-enabled servers using Azure Monitor
- Secure your Azure Arc-enabled servers using Microsoft Defender for servers
- Gain security insights from your Arc-enabled servers using Microsoft Sentinel
- Keep your Azure Arc-enabled servers patched using Azure Update Manager
- Monitor changes to your Azure Arc-enabled servers using Change tracking and inventory
- SSH into your Azure Arc-enabled servers using SSH access
- Run scripts in your Arc-enabled Windows server by using Run Commands
- Run automation runbooks on your Azure Arc-enabled servers using Hybrid runbook workers
- Configure your Azure Arc-enabled servers using Azure Automanage machine configuration
- Manage the Windows operating system of your Arc-enabled servers using Windows Admin Center
- Query and inventory your Azure Arc-enabled servers using Azure Resource Graph
- Enforce governance across your Azure Arc-enabled servers using Azure Policy
- Enroll your Windows Server 2012/R2 or SQL Server 2012 machines for Extended Security Updates through Azure Arc

| LevelUp Module | Duration | Facilitator |
|---------------|---------------|---------------|
|[**Understand pre-requisites to onboard Windows and Linux servers to Azure Arc**](#levelup-lab-environment) | 15 minutes |  |
|[**1 - Onboard Windows and Linux servers running using different onboarding methods**](#module-1-on-boarding-to-azure-arc-enabled-servers) | 30 minutes |  |
|[**2 - Monitor your Azure Arc-enabled servers using Azure Monitor**](#module-2-monitor-your-azure-arc-enabled-servers-using-azure-monitor) | 45 minutes |  |
|[**3 - Secure your Azure Arc-enabled servers using Microsoft Defender for servers**](#module-3-secure-your-azure-arc-enabled-servers-using-microsoft-defender-for-servers) | 15 minutes |  |
|[**4 - Gain security insights from your Arc-enabled servers using Microsoft Sentinel**](#module-4--gain-security-insights-from-your-arc-enabled-servers-using-microsoft-sentinel) | 15 minutes |  |
|[**5 - Keep your Azure Arc-enabled servers patched using Azure Update Manager**](#module-5-keep-your-azure-arc-enabled-servers-patched-using-azure-manager) | 15 minutes |  |
|[**6 - Monitor changes to your Azure Arc-enabled servers using Change tracking and inventory**](#module-6-monitor-changes-to-your-azure-arc-enabled-servers-using-change-tracking-and-inventory) | 30 minutes |  |
|[**7 - Configure your Azure Arc-enabled servers using Azure Automanage machine configuration**](#module-7-configure-your-azure-arc-enabled-servers-using-azure-automanage-machine-configuration) | 45 minutes |  |
|[**8 - Query and inventory your Azure Arc-enabled servers using Azure Resource Graph**](#module-8-query-and-inventory-your-azure-arc-enabled-servers-using-azure-resource-graph) | 15 minutes |  |
|[**9 - Enforce governance across your Azure Arc-enabled servers using Azure Policy**](#module-9-enforce-governance-across-your-azure-arc-enabled-servers-using-azure-policy) | 15 minutes |  |


## LevelUp Lab Environment

ArcBox LevelUp edition is a special “flavor” of ArcBox that is intended for users who want to experience Azure Arc-enabled servers' capabi
ties in a sandbox environment. Screenshot below shows layout of the lab environment.

  ![Screenshot showing ArcBox architecture](ArcBox-architecture.png)

### Prerequisites

To complete this laby you require a browser and internet access. It is recommended to use InPrivate / Incognito mode to avoid accidently using your existing work/personal credentials.

The initial Azure resources required to complete this lab have already been deployed in your allocated Azure resource group.

However if you wish to complete this lab later in your own subscription, use the following link to deploy the same base configuration:

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Feldridgeb%2Fanz-hybrid-labs%2Fmain%2FARM%2Fazuredeploy.json" target="_blank"><img src="https://aka.ms/deploytoazurebutton"/></a>

The parameters can be mostly left with their default values, though feel free to customise if you wish (e.g. setting your email address for notifications).

### Azure portal login

- Login to the [Azure portal](https://portal.azure.com) using the credentials provided by your instructor
- If prompted to configure MFA, select *Ask later* (yes this is generally a bad idea, however these are temporary credentials used just for today's lab)

### Connecting to the ArcBox Client virtual machine

Use the following credentials to login to the ArcBox-Client Azure VM:

| Username | Password |
|---------------|---------------|
| arc-admin | HardPass123! |

We'll be using Azure [Azure Bastion](https://azurearcjumpstart.io/azure_jumpstart_arcbox/ITPro/#connect-using-azure-bastion)


#### Connect using Azure Bastion

- If you have chosen to deploy Azure Bastion in your deployment, use it to connect to the VM.

  ![Screenshot showing connecting to the VM using Bastion](./bastion_connect.png)

  > **NOTE: When using Azure Bastion, the desktop background image is not visible. Therefore some screenshots in this guide may not exactly match your experience if you are connecting to _ArcBox-Client_ with Azure Bastion.**


#### The Logon scripts

- When the lab environment was first created, multiple automated scripts were run to pre-configure the Hyper-V environment. These scripts usually take 10-20 minutes to finish, and once completed, the script windows will close automatically. These scripts should have finshed by the time you start the lab. However if you see the scripts running, please allow them time to complete. If the scripts are still running or you see any errors, please discuss with your guide.

  ![Screenshot showing ArcBox-Client](./automation.png)

- Deployment is complete! Let's begin exploring the features of Azure Arc-enabled servers with the Level-up modules.

  ![Screenshot showing complete deployment](./arcbox_complete.png)

  ![Screenshot showing ArcBox resources in Azure portal](./rg_arc.png)

## Modules

### Module 1: On-boarding to Azure Arc-enabled servers

#### Module overview: In this module we will connect two machines (Windows and Linux) to Azure Arc

#### Task 1: Examine the existing Arc-connected machines

- The deployment process that you have walked through should have set up four VMs running on Hyper-V in the ArcBox-Client machine. Two of these machines have been connected to Azure Arc already. Let us have a look at these in the Azure Portal

- Enter "Machines - Azure Arc" in the top search bar in the Azure portal and select it from the displayed services.

    ![Screenshot showing how to display Arc connected servers in portal](./Arc_servers_search.png)

- We should see the machines that are connected to Arc already: Arcbox-Ubuntu-01 and ArcBox-Win2K19.

    ![Screenshot showing existing Arc connected servers](./First_view_of%20Arc_connected.png)

- We want to connect the other 2 machines running as VMs in the ArcBox-Client. We can see these (ArcBox-Win2K22 and ArcBox-Ubuntu-02) by running the Hyper-V Manager in the ArcBox-Client (after we have connected to it with RDP as explained earlier in the setup).

    ![Screenshot of 4 machines on Hyper-v](./choose_Hyper-V.png)

#### Task 2: Onboard a Windows machine to Azure Arc

- We will onboard the Windows machine ArcBox-Win2K22 using the [Service Principal onboarding method](https://learn.microsoft.com/en-us/azure/azure-arc/servers/onboard-service-principal).

- For this lab environment, a service principal called `Arc server onboarding account` had already been created and granted the `Azure Connected Machine Onboarding` role, so you don't need to complete the next 2 steps. Your lab instructor will provide the service principal secret.

- We will use Azure Cloud Shell to run some Azure PowerShell commands. From the Azure Portal, select the Cloud Shell icon in the top right to open Cloud Shell. Select the PowerShell option (not Bash) to create the environment. 

- Using the following Powershell commands create a service principal and assign it the Azure Connected Machine Onboarding role for the selected subscription. After the service principal is created, it will print the application ID and secret (copy these somewhere safe for later use). Note :

  ```powershell
  $sp = New-AzADServicePrincipal -DisplayName "Arc server onboarding account" -Role "Azure Connected Machine Onboarding"
  $sp | Format-Table AppId, @{ Name = "Secret"; Expression = { $_.PasswordCredentials.SecretText }}
  ```

- Next we will generate a script to automate the download and installation, and to connect to Azure Arc.

- From the Azure portal go to the "Machines - Azure Arc" page and select "Add/Create" at the upper left, then select "Add a machine".

    ![Screenshot to select add a machine](./Select_Add_a_machine.png)

- In the next screen, go to "Add multiple severs" and click on "Generate script".

    ![Screenshot Add Multiple Servers Script](./Add_multiple_servers_script.png)

- Fill in the Resource Group, Region, Operating System (Windows), keep Connectivity as "Public endpoint" and in the Authentication box select the onboarding service principal that you created in this task. Then download the script to your local machine (or you can copy the content into the clipboard).

- Go to the ArcBox-Client machine via RDP and from Hyper-V manager right-click on the ArcBox-Win2K22 VM and click "Connect" (Administrator default password is JS123!!). Then start Windows Powershell ISE in the ArcBox-Win2K22 VM and copy the content of the onboarding script in the Script Pane.

- Fill in the Service Principal secret in the script and run it.

    ![Screenshot run onboard windows script](./run_windows_onboard_sctipt.png)

- On successful completion a message is displayed to confirm the machine is connected to Azure Arc. We can also verify that our Windows machine is connected in the Azure portal (Machines - Azure Arc).

    ![Screenshot confirm win machine on-boarded](./confirm_windows_machine_onboarding.png)

#### Task 3: Onboard a Linux machine to Azure Arc

- We will now onboard the Linux vm ArcBox-Ubuntu-02 to Azure Arc using the same service principal method we used above for the Windows machine. We can use the same service principal we created above.

- From the Azure portal go to the "Machines - Azure Arc" page and select "Add/Create" at the upper left, then select "Add a machine".

- In the next screen, go to "Add multiple severs" and click on "Generate script".

- Fill in the required details but this time choose Linux for the Operating System box. Then download the script to your local machine (or you can copy the content into the clipboard).

- Add the client secret to the script using your editor. **Also add** the following 3 firewall commands just below the last export statement (to allow onboarding of Azure linux machines):

  ```shell
  sudo ufw --force enable
  sudo ufw deny out from any to 169.254.169.254
  sudo ufw default allow incoming
  ```

- Connect the the ArcBox-Client machine, and from the "Networking" tab on Hyper-v Manager find the IP address of the Linux machine.

    ![Screenshot IP address of second Ubuntu machine](./IP_address_second_Linux_vm.png)

- From the ArcBox-Client Azure VM, SSH into the ArcBox-Ubuntu-02 machine using "Putty" or "Vscode".

    ![Screenshot connect with putty](./putty.png)

- Enter the user name and password (defaults "jumpstart" and "JS123!!") and log-in to the Linux VM.

- Create an empty onboarding script file using the nano editor, and paste the script content from your local machine (you can paste by right-clicking inside the nano editor window).

  ```shell
  nano onboardingscript.sh
  ```

- Save the file (Ctrl-O then Enter) and exit (Ctrl-X). Now you can run the script:

  ```shell
  sudo bash ./onboardingscript.sh
  ```

- Wait for the script to finish successfully. A message should confirm that the machine is now Arc-connected. We can also verify that our Windows machine is connected in the Azure portal (Machines - Azure Arc). **If the script returns an error then check that you have added the three firewall (ufw) commands mentioned above.**

    ![Screenshot Linux message confirm connection](./Linux_%20message_confirm_connection.png)

### Module 2: Monitor your Azure Arc-enabled servers using Azure Monitor

#### Module overview

In this module, you will learn how to deploy the Azure Monitor agent to your Arc-enabled Windows and Linux machines, the dependency agent to your Arc-enabled Windows machines and enable the _VM Insights_ solution to start monitoring your machines using Azure Monitor, run queries on the Log analytics workspace and configure alerts.

#### Pre-requisites

- Make sure that the policy _Enable Azure Monitor for Hybrid VMs with AMA_ is not assigned or inherited on the subscription you will use for this level-up.

#### Task 1: Deploy Azure Monitor agents and VM Insights using Azure Policy

Azure Policy lets you set and enforce requirements for all new resources you create and resources you modify. VM insights policy initiatives, which are predefined sets of policies created for VM insights, install the agents required for VM insights and enable monitoring on all new virtual machines in your Azure environment.

- In the Azure portal, search for _Policy_.

    ![Screenshot showing searching for Policy in the azure portal](./portal_policy_search.png)

- Click on "Definitions" and search for the _(ArcBox) Deploy Azure Monitor on Arc-enabled Windows machines_ policy.

    ![Screenshot showing searching for the arcbox policies](./policy_arcbox.png)

- Click "Assign Initiative".

    ![Screenshot showing assigning the policy](./policy_monitor_windows_assign.png)

- Select the right scope (management group, subscription and resource group) for the resource group where you deployed _ArcBox_.

    ![Screenshot showing assigning the policy to the right scope](./policy_monitor_windows_scope.png)

- After validating the scope, click "Next" twice to navigate to the parameters tab.

    ![Screenshot showing assigning the policy initiative to the right scope](./policy_monitor_windows_dcr_blank.png)

- To get the "Data Collection Rule" resource Id,  run the following CLI command

  ```shell
  az resource show --name "arcbox-ama-vmi-perfAndda-dcr" `
                   --resource-group "<resource group name>" `
                   --resource-type Microsoft.Insights/dataCollectionRules `
                   --query id `
                   --output tsv
  ```

- You can also find the "Data Collection Rule" resource Id from the Azure portal. Search for the _arcbox-ama-vmi-perfAndda-dcr_ data collection rule.

    ![Screenshot showing searching for data collection rules](./dcr_search_portal.png)

    ![Screenshot showing getting the data collection rules resource Id](./dcr_vm_insights.png)

    ![Screenshot showing getting the data collection rules resource Id](./dcr_json_view.png)

    ![Screenshot showing getting the data collection rules resource Id](./dcr_resource_id.png)

    ![Screenshot showing adding the data collection rules resource Id](./policy_monitor_windows_create.png)

    > **NOTE:The policy will take 5-15 minutes to assess the current resources.**

- After the policy has reported compliance, create a remediation task to remediate existing machines.

    ![Screenshot showing the ama policy not compliant](./policy_monitor_windows_non_compliant.png)

    ![Screenshot showing creating the remediation task](./policy_monitor_windows_create_remediation.png)

    ![Screenshot showing creating the remediation task](./policy_monitor_windows_remediate.png)

> **NOTE: When creating the remediation task, make sure to select the same region where you deployed ArcBox**

- Create one remediation task per policy definition in the initiative.

    ![Screenshot showing creating the remediation task](./policy_monitor_windows_create_remediation_multiple.png)

- After all remediation tasks have completed. You should see the Azure Monitor agent extension and the dependency agent extension deployed to the Arc-enabled machines.

    ![Screenshot showing the remediation tasks successful](./policy_monitor_windows_remediate_tasks.png)

    ![Screenshot showing the monitoring agents installed](./machine_windows_ama_agents.png)

- (Optional) Repeat the same steps in _Task 2_ to assign the Linux policy for data collection _(ArcBox) Deploy Azure Monitor on Arc-enabled Linux machines._

- After configuring the agents and VM insights using Azure Policy, it will take 10-25 minutes for the insights data to start showing up.

   ![Screenshot showing VM insights on the Windows Arc-enabled machine](./machine_vm_insights.png)

   ![Screenshot showing VM insights on the Linux Arc-enabled machine](./machine_vm_insights_linux.png)

#### Task 2: Configure data collection for logs and metrics

As part of the ArcBox automation, some alerts and workbooks have been created to demonstrate the different monitoring operations you can perform after onboarding the Arc-enabled machines. You will now configure some data collection rules to start sending the needed metrics and logs to the Log Analytics workspace.

- In the Azure portal, search for _Data Collection rules_.

    ![Screenshot showing searching for data collection rules](./dcr_search_portal.png)

- Create a new data collection rule.

    ![Screenshot showing creating a new data collection rule](./alerts_dcr_create.png)

- Provide a name and select the same resource group where ArcBox is deployed. Make sure to select Windows as the operating system.

    ![Screenshot showing creating a new data collection rule](./alerts_dcr_basics.png)

- In the "Resources" tab, select the right resource group and the Arc-enabled servers onboarded.

    ![Screenshot showing adding resources to the data collection rule](./alerts_dcr_resources.png)

- Add a new "Performance Counters" data source, and make sure to select all the custom counters.

    ![Screenshot showing adding performance counters to the data collection rule](./alerts_dcr_counters.png)

- Add a new "Azure Monitor Logs" destination and select the log analytics workspace deployed in the ArcBox resource group and save.

    ![Screenshot showing adding performance counters to the data collection rule](./alerts_dcr_counters_destination.png)

- Add a new "Windows Event logs" data source.

    ![Screenshot showing adding log data source to the data collection rule](./alerts_dcr_windows_logs_source.png)

- Select _Critial_, _Error_, _Warning_ events in the Application and System logs and add the data source.

    ![Screenshot showing adding log data source to the data collection rule](./alerts_dcr_windows_logs_types.png)

- Save and create the data collection rule.

- Repeat the previous steps to create another Linux data collection rule.

    ![Screenshot showing creating a new linux data collection rule](./alerts_dcr_linux_basics.png)

    ![Screenshot showing adding resources to the data collection rule](./alerts_dcr_resources_linux.png)

    ![Screenshot showing adding logs to the data collection rule](./alerts_dcr_logs_linux.png)

- After waiting for 5-10 minutes for the data collection rule to start collecting data, restart the servers in the Hyper-V manager on the _ArcBox-Client_ VM to trigger some new events.

    ![Screenshot showing restarting the vms in the hyper-v manager](./alerts_hyperv_restart.png)

#### Task 3: View alerts and visualizations

> **NOTE: It might take some time for all visualizations to load properly**

- In Azure Monitor, click on _Alerts_. and select _Alert rules_

    ![Screenshot showing opening the alerts page](./alerts_rules_open.png)

- Explore the alert rules crated for you.

    ![Screenshot showing opening one alert around processor time](./alerts_rules_rules.png)

- Go back to Azure Monitor and click on _Workbooks_. There are three workbooks deployed for you.

    ![Screenshot showing deployed workbooks](./alerts_workbooks_list.png)

    ![Screenshot showing alerts workbook](./alerts_workbooks_alerts.png)

    ![Screenshot showing performance workbook](./alerts_workbooks_perf.png)

    ![Screenshot showing events workbook](./alerts_workbooks_events.png)

### Module 3: Secure your Azure Arc-enabled servers using Microsoft Defender for servers

#### Module overview

In this module, you will learn how to enable and leverage Microsoft Defender for Servers to secure your Azure Arc-enabled servers using capabilities like Defender for Endpoint, vulnerability assessment and threat detection via alerts.

#### Task 1: Pre-requisites

> **NOTE: In the previous module, you should have already deployed the Azure Monitor agent (AMA) to you Arc-enabled servers. If you have not deployed it, follow the following steps in module 2 to deploy it otherwise skip to task 2**

#### Task 2: Enable the Defender for Servers plan

- **Note:** Defender for Servers should already be enabled in the Azure subscription used during this lab, so the following steps can be skipped. 

- From the Azure home page, search for defender and select Microsoft Defender for Cloud.

    ![Screenshot showing searching for Defender for Cloud in the Azure Portal](./defenderForCloud_portal_search.png)

- If you already have Defender plans setup at your subscription level, you may find that Defender is already turned on for your Arc-enabled servers. However, if Defender is not enabled, select _Environment settings_ from the Management section on the left blade.

    ![Screenshot showing selecting the right subscription to enableDefender for Cloud in the Azure Portal](./defenderForCloud_portal_env_settings.png)

- Expand the Tenant Root Group, and then select your subscription.

- Enable the plan for servers, you can select either _Plan 1_ or _Plan 2_ for this exercise

    ![Screenshot showing enabling Defender for servers plan in the Azure Portal](./defenderForCloud_portal_servers_enable.png)

- Click on the settings option in the _Monitoring coverage_ and enable the following capabilities:
  - Vulnerability assessment for machines
  - Endpoint protection

    ![Screenshot showing configuring Defender for servers plan 1 in the Azure Portal](./defenderForCloud_portal_servers_settings.png)

- Click Save.

    ![Screenshot showing configuring Defender for servers plan 1 in the Azure Portal](./defenderForCloud_portal_save.png)

#### Task 3: Detect threats on your servers using alerts

  > **NOTE: Alerts may not be visibile in the lab environment due to access restrictions - considering skipping to task 4**

- To simulate a malicious activity on the _Win2k22_ servers, rdp into the _ArcBox-Client_ VM
- Go to Start and type _PowerShell ISE_.
- Right-select and select Run as administrator.

    ![Screenshot showing opening cmd as administator](./powershellISE_runas.png)

- Run the following command:

  ```shell
  $remoteScriptFile = "$agentScript\testDefenderForServers.cmd"
  $Win2k22vmName = "ArcBox-Win2K22"
  $nestedWindowsUsername = "Administrator"
  $nestedWindowsPassword = "JS123!!"
  $secWindowsPassword = ConvertTo-SecureString $nestedWindowsPassword -AsPlainText -Force
  $winCreds = New-Object System.Management.Automation.PSCredential ($nestedWindowsUsername, $secWindowsPassword)
  $cmdExePath = "C:\Windows\System32\cmd.exe"
  $cmdArguments = "/C `"$remoteScriptFile`""

  Invoke-Command -VMName $Win2k22vmName -ScriptBlock { Start-Process -FilePath $Using:cmdExePath -ArgumentList $Using:cmdArguments } -Credential $winCreds
  ```

  ![Screenshot showing running the Defender alert trigger script in ISE](./run_defender_alert_trigger.png)

- Navigate to the Security tab of the _Win2k22_ Arc-enabled server in the portal

    ![Screenshot showing the generated alert](./defenderForCloud_portal_alert.png)

  > **NOTE: You should already see an alert for the Win2k19 Arc-enabled server**

- You can also see the alerts from the _Defender for Cloud_ portal, in the _Security alerts_ pane.

    ![Screenshot showing the generated alert](./defenderForCloud_portal_alert_mdfc.png)

  > **NOTE: If you don't see the alerts, make sure to select the Information severity in the filters**

    ![Screenshot showing the generated alert filters](./defenderForCloud_portal_alert_filter.png)

#### Task 4: Enable vulnerability assessment

- After waiting for 30-45 minutes, you should start seeing recommendations for the Arc-enabled machines in the "Security" blade.

> **NOTE: It might take several hours before this recommendation start to appear**

- You should find the recommendation _Machines should have vulnerability findings resolved_ if the vulnerability assessment has been enabled automatically on the subscription.

    ![Screenshot showing defender recommendations](./defenderForCloud_portal_recommendation_vulnerabilities.png)

    ![Screenshot showing defender recommendations](./defenderForCloud_portal_vulnerabilities_list.png)

- If you do not see this recommendation, click on the _Machines should have a vulnerability assessment solution installed_

    ![Screenshot showing defender recommendations](./defenderForCloud_portal_recommendations.png)

- Click on the "Machines should have a vulnerability assessment solution" recommendation and click "fix"

    ![Screenshot showing fixing the recommendation](./defenderForCloud_portal_recommendation_fix.png)

    ![Screenshot showing fixing the recommendation](./defenderForCloud_portal_enable_vulnrability.png)

    ![Screenshot showing fixing the recommendation](./defenderForCloud_portal_recommendation_fix_resource.png)

    ![Screenshot showing fixing the recommendation](./defenderForCloud_portal_recommendation_fix_success.png)

> **NOTE: The same steps can be applied to the Linux Arc-enabled machines**

### Module 4 : Gain security insights from your Arc-enabled servers using Microsoft Sentinel

#### Module overview

In this module you will configure Windows security events collection using Sentinel to inspect failed logins on your Windows Arc-enabled machine

#### Task 1: Configure data collection on Sentinel

- In the Azure Portal, search for _Sentinel_

    ![Screenshot showing searching for Sentinel on the Azure Portal](./portal_search_sentinel.png)

- Click on "Content Hub" and search for "Windows Security Events" and install it.

    ![Screenshot showing searching for windows security events](./sentinel_content_hub.png)

- After installation, click on "Manage" to configure the collector.

    ![Screenshot managing the data collection](./sentinel_manage_data_collector.png)

- Select the data connector and make sure you've selected the _Windows Security Events via AMA_ and click "open connector page".

    ![Screenshot selecting the AMA data collection](./sentinel_data_collector_ama.png)

- Create a new data collection rule.

    ![Screenshot showing creating a new data collection rule](./sentinel_create_new_dcr.png)

- Provide a name for the data collection rule and select the same resource group where you've deployed this level-up lab.

    ![Screenshot selecting the data collection rule name](./sentinel_dcr_creation.png)

- Select one or multiple Windows Arc-enabled machines.

    ![Screenshot selecting the arc machines](./sentinel_dcr_select_server.png)

- Select the "Common" event type and create the data collection rule.

    ![Screenshot selecting the common event type](./sentinel_security_events_common.png)

    ![Screenshot selecting the AMA data collection created](./sentinel_security_events_created.png)

#### Task 2: Simulating and viewing security events

- After configuring Sentinel, now we need to simulate some failed login attempts on one or more Windows Arc-enabled machines.

- Connect to _ArcBox-Client_ VM, and open the _Hyper-v manager_.

- Right-click one of the Windows machines and connect to it.

    ![Screenshot showing connecting to the nested vm on hyper-v](./hyperv_connect_vm.png)

- Simulate some failed login attempts by trying to login multiple times using an incorrect password.

    ![Screenshot showing failed login attemps on the nested vm](./hyperv_failed_login.png)

- After waiting for about 10-15 minutes for data to start getting ingested into the log analytics workspace, navigate to "Workbooks" and select the "Identity & Access" workbook.

    ![Screenshot selecting the Identity and access workbook](./sentinel_open_workbook.png)

- Once data is being ingested, you will start seeing the failed login attempts in the workbook.

    ![Screenshot selecting the Identity and access workbook](./sentinel_failed_login.png)

### Module 5: Keep your Azure Arc-enabled servers patched using Azure Update Manager

#### Module overview

Azure Update Manager is a service that unifies all VMs running in Azure together with Azure Arc, putting all update tasks in 1 common area for all supported Linux and Windows versions.
This service is NOT dependent on Log analytics agent. (The older Azure Automation Update service relies on Log Analytics agent)

Extended Security Updates (ESU) for older Windows like Windows 2012 and 2012R2 are also available through this service (Free for Azure VMs, and an opt-in paid service for Arc).
These modules will take a while to run, up to 15 minutes for each VM, due to processing required at the various VMs, although it is all running simultaneously.


#### Onboarding the Arc-enabled servers

Note that all Azure VMs and Arc Server VMs are already visible in this Azure Update Manager service.

   ![Screenshot showing initial view of all VMs](./updatemgmt-allvms.png)

#### Refresh the VMs

- Once the VMs have been onboarded, clicking on the refresh button will refresh the current status of selected VMs.
This can also be set as an automatic recurring task for at scale refresh - once every 24 hours. This automatic refresh interval cannot be changed.

   ![Screenshot showing automatic refresh configuration](./updatemgmt-updatesettings.png)

#### Setup Maintenance Configuration

- Setup a list of maintenance configurations for each specific group of VMs in your environment. For countries in Asia and Europe, it is a good idea to use second Tuesday + 1 day to coincode with Patch Tuesday. Do not use "Second Wednesday of the month".

   ![Screenshot showing how to add a maintenance config](./updatemgmt-maintenanceconfig.png)

- Then choose how machines are added to this maintenance configuration (by OS, location, resource group)

   ![Screenshot showing the dynamic scopes for update groups](./updatemgmt-dynamicscopes.png)

>**Note: If you want to enable dynamic scopes, you will need to enable the "Dynamic Scoping" preview feature in the subscription. This may not work for the lab environment due to access limitations.

   ![Screenshot showing the dynamic scopes for update groups](./updatemgmt-previewdynamicscope.png)

- Or choose machines specifically instead of dynamically

   ![Screenshot showing which machines to be selected for config](./updatemgmt-specificmachineselection.png)

- Then choose what type of updates will be installed by this config

   ![Screenshot showing which updates are going to be installed](./updatemgmt-specificupdates.png)

#### Forcing one-time updates

- Instead of using maintenance configs with specific recurring cycles, you can also setup one-time updates (immediately!). Start by forcing an immediate refresh.

   ![Screenshot showing onetime refresh](./updatemgmt-onetimerefresh.png)

- Then specify which machines

   ![Screenshot showing what updates for each machines](./updatemgmt-installonetimeupdates.png)

- Choose which types of updates

   ![Screenshot showing which types of updates to install](./updatemgmt-showwhichupdates.png)

- Look at the update options

   ![Screenshot showing changes to be made in the onboard script](./updatemgmt-installoptions.png)

- Then wait for a few hours and a few reboots - this can take repeated forcing for machines that have not been updated for a long time

   ![Screenshot showing final state](./updatemgmgt-allupdatescompleted.png)

#### Reporting

Under the Monitoring part of the Update Manager, there is a default workbook, which is an overview of the Azure Update Manager. There are a few views in there that show the total number of machines connected, history of runs, and the status.

- View of currently connected machines, split by Azure and Azure Arc VMs, and Windows and Linux numbers.

   ![Screenshot showing overall machine Status](./updatemgmt-reporting1.png)

- View of manual vs periodic assessments and manual vs automatically updated.

   ![Screenshot showing overall machine Status](./updatemgmt-repoting2.png)

- View of updates by classification

   ![Screenshot showing overall machine Status](./updatemgmt-reporting3.png)

#### Module recap

In this session, you have setup Update Management and learnt how to enable it to efficiently manage all updates for your machines, regardless of where they are.
You have also seen some of the default reports, and since they use workbooks, you can easily create your own customized reports.

### Module 6: Monitor changes to your Azure Arc-enabled servers using Change Tracking and Inventory

#### Module overview

Change Tracking and Inventory is an built-in Azure service, provided by Azure Automation. The old version uses the Log Analytics agent, while the newer version uses the Azure Monitor Agent (AMA).

> **NOTE: Some instructions and screenshots refer to the older preview experience and will be slightly different in the current Azure portal.

#### Prerequisites

The following are required for this module to function:

1. Ensure that the servers are already on-boarded to Azure Arc (As in Module 1).
2. Ensure that the Azure Monitor agent (AMA) is already deployed on every Arc-enabled server (As in Module 2).


#### Current Limitations

The following table lists the current limitations for Change Tracking And Inventory

https://learn.microsoft.com/azure/automation/change-tracking/overview-monitoring-agent?tabs=win-az-vm#current-limitations


#### Task 1: Enabling Change Tracking

> **NOTE: This task usually requires the following:

>1. Setting up a Data Collection Rule that would collect the right events and data.
>2. Creating an Azure policy to onboard your Arc-enabled machines to Change Tracking.
**

For the purposes of this levelup - these tasks have all been done for you, so you do not need to do them manually.
Follow the link [here](https://learn.microsoft.com/azure/automation/change-tracking/enable-vms-monitoring-agent?tabs=multiplevms%2Carcvm) to know how to do these yourself in future.

Verify that Change Tracking is enabled by going to the portal and selecting the windows server e.g. ArcBox-Win2K19 from Arc Machines. Select "Settings" from the "Change tracking" page:

   ![Screenshot showing Change Tracking](./CT_1_verify-.png)

#### Task 2: Track changes in Windows services

- From the "Change tracking" settings select "Windows Services" and change the "Collection Frequency" to 10 minutes.

   ![Screenshot CT Windows Services settings](./CT_2_WinServices.png)

- Try stopping the "Print Spooler" service on the Arc machine ArcBox-Win2k19 using an administrative powershell session (or from the Services desktop application).

  ```PowerShell
  Stop-Service spooler
  ```

- The service changes will eventually show up in the "Change tracking" page for the server ArcBox-Win2K19.
(By default Windows services status are updated every 30 minutes but you changed that to 10 minutes earlier to speed up the result for this task).

   ![Screenshot CT Spooler stopped](./CT_3_WinServices-spooler.png)

- You can restart the spooler service on the server if you wish and change tracking will show the outcome in the portal after few minutes.

  ```PowerShell
  Start-Service spooler
  ```


#### Task 3: Track File Changes

- Navigate to one of the Arc-enabled Windows machines and select "Change tracking" then select "Settings" then select "Windows Files". You should see the "Add windows file setting" screen on the right hand side. Configure these settings to track the changes to the file "c:\windows\system32\drivers\etc\hosts" and to upload the file content.


  ![Screenshot showing Edit windows file Settings](./CT_4_File-Settings.png)

- Now set the file location where changed files will be uploaded. You should have a storage account deployed in the resource group of this level-up.

  ![Screenshot showing Storage Account Settings](./CT_5_File-Location.png)

- Navigate to the storage account. Click on "Containers" and you should see a container created automatically for you by Azure Change Tracking.

  ![Screenshot storage container for CT](./CT_6_CT-Storage-Container.png)

  - Click on the "changetrackingblob" container, and in the next page select "Access Control (IAM)", then on "Add role assignment"

  ![Screenshot blob IAM](./CT_7_CT-Storage-Container-Access.png)

  - Select the Storage Blob Data Contributor role

  ![Screenshot blob contributor](./CT_8_CT-BlobDataContributor.png)

  - Assign the role to the Windows Arc enabled machines managed identity.

  ![Screenshot assign VM data contributor role](./CT_9_CT-BlobDataContributor-VM.png)


- Modify the hosts file on the "ArcBox-Win2K19" machine (c:\Windows\System32\Drivers\etc\hosts).

> **NOTE: To modify the hosts file, open _Notepad_ as administrator, select File>Open, and then browse to c:\Windows\System32\Drivers\etc\hosts file**

- Add a line like this from an administrative notepad and save the file.

  ```shell
  1.1.1.1      www.fakehost.com
  ```

- Eventually, the file changes will show up in the change tracking page of the machine. The file changed content will also be uploaded to the "changetrackingblob" storage container.

#### Task 4: Alert Configuration

- If you want to be alerted when someone changes a host file on any one of your server, then configure alerting.

- On the Change tracking page from your Arc-enabled machine, select "Log Analytics".

- In the Logs search, look for content changes to the hosts file with the query.

   ```shell
   ConfigurationChange | where FieldsChanged contains "FileContentChecksum" and FileSystemPath == "c:\\windows\\system32\\drivers\\etc\\hosts"
   ```

- In Log Analytics, alerts are always created based on log analytics query result.

- Check your query again and modify the alert logic. In this case, you want the alert to be triggered if there's even one change detected across all the machines in the environment.

### Module 7: Configure your Azure Arc-enabled servers using Azure Automanage machine configuration

#### Module overview

In this module, you will learn to create and assign a custom Automanage Machine Configuration to an Azure Arc-enabled Windows and Linux servers to create a local user and control installed roles and features.

#### Task 1 : Create Automanage Machine Configuration custom configurations for Windows

We will be using the ArcBox Client virtual machine for the configuration authoring.

- RDP into the _ArcBox-Client_ VM

- Open Visual Studio Code from the desktop shortcut.

- Create C:\ArcBox\MachineConfiguration.ps1, then paste and run the following commands to complete the steps for this task:

> **NOTE: To run each additional code snippet you paste in VSCode, highlight the code you need to run and press F8**

  ![Screenshot showing VSCode code execution](./vscode_code_execution.png)

##### Custom configuration for Windows

- Initialize variables and login to Azure. Add the service principal ID and secret into the variables below, using the same details as provided for module 1.

```PowerShell
$resourceGroupName = $env:resourceGroup
$location = $env:azureLocation
$spnTenantId = $env:spnTenantId
$Win2k19vmName = "ArcBox-Win2K19"
$Win2k22vmName = "ArcBox-Win2K22"

$spnClientId = "<Replace with service principal ID>"
$spnClientSecret = "<Replace with service principal secret>"

$SecurePassword = ConvertTo-SecureString -String $spnClientSecret -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $spnClientId, $SecurePassword
Connect-AzAccount -ServicePrincipal -TenantId $spnTenantId -Credential $Credential
```

- When prompted, authenticate with the same username and password used to access the Azure portal.


- Install the needed PowerShell modules.

```PowerShell
Install-Module -Name Az.Accounts -Force -RequiredVersion 2.15.1
Install-Module -Name Az.PolicyInsights -Force -RequiredVersion 1.6.4
Install-Module -Name Az.Resources -Force -RequiredVersion 6.15.1
Install-Module -Name Az.Storage -Force -RequiredVersion 6.1.1
Install-Module -Name MSI -Force -RequiredVersion 3.3.4
Install-Module -Name GuestConfiguration -Force -RequiredVersion 4.5.0
Install-Module PSDesiredStateConfiguration -Force -RequiredVersion 2.0.7
Install-Module PSDscResources -Force -RequiredVersion 2.12.0.0
```

- Run _Get-InstalledModule_ to validate that the modules have installed successfully.

The Azure PowerShell modules are used for:

- Publishing the package to Azure storage
- Creating a policy definition
- Publishing the policy
- Connecting to the Azure Arc-enabled servers

The GuestConfiguration module automates the process of creating custom content including:

- Creating a machine configuration content artifact (.zip)
- Validating the package meets requirements
- Installing the machine configuration agent locally for testing
- Validating the package can be used to audit settings in a machine
- Validating the package can be used to configure settings in a machine

Desired State Configuration version 3 is removing the dependency on MOF.
Initially, there are only support for DSC Resources written as PowerShell classes.
Due to using MOF-based DSC resources for the Windows demo-configuration, we are using version 2.0.5.

- Create a storage account to store the machine configurations

  ```PowerShell
  $storageaccountsuffix = -join ((97..122) | Get-Random -Count 5 | % {[char]$_})
  New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name "machineconfigstg$storageaccountsuffix" -SkuName 'Standard_LRS' -Location $Location -OutVariable storageaccount -EnableHttpsTrafficOnly $true -AllowBlobPublicAccess $true | New-AzStorageContainer -Name machineconfiguration -Permission Blob
  ```

- Create the custom configuration

  ```PowerShell
  Import-Module PSDesiredStateConfiguration -RequiredVersion 2.0.7

  Configuration AzureArcLevelUp_Windows
  {
      param (
          [Parameter(Mandatory)]
          [System.Management.Automation.PSCredential]
          [System.Management.Automation.Credential()]
          $PasswordCredential
      )

      Import-DscResource -ModuleName 'PSDscResources' -ModuleVersion 2.12.0.0

      Node localhost
      {
          MsiPackage PS7
          {
              ProductId = '{AA89DEED-9030-494E-9F28-53A4D9B55D12}'
              Path = 'https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/PowerShell-7.4.6-win-x64.msi'
              Ensure = 'Present'
          }
          User ArcBoxUser
          {
              UserName = 'arcboxuser1'
              FullName = 'ArcBox User 1'
              Password = $PasswordCredential
              Ensure = 'Present'
          }
          WindowsFeature SMB1 {
              Name = 'FS-SMB1'
              Ensure = 'Absent'
          }
      }
  }
  Write-Host "Creating credentials for arcbox user 1"
  $nestedWindowsUsername = "arcboxuser1"
  $nestedWindowsPassword = "ArcDemo123!!"  # In real-world scenarios this could be retrieved from an Azure Key Vault

  # Create Windows credential object
  $secWindowsPassword = ConvertTo-SecureString $nestedWindowsPassword -AsPlainText -Force
  $winCreds = New-Object System.Management.Automation.PSCredential ($nestedWindowsUsername, $secWindowsPassword)

  $ConfigurationData = @{
      AllNodes = @(
          @{
              NodeName = 'localhost'
              PSDscAllowPlainTextPassword = $true
          }
      )
  }
  $OutputPath = "$Env:ArcBoxDir/arc_automanage_machine_configuration_custom_windows"
  New-Item $OutputPath -Force -ItemType Directory
  ```

- Execute the newly created configuration.

  ```PowerShell
  AzureArcLevelUp_Windows -PasswordCredential $winCreds -ConfigurationData $ConfigurationData -OutputPath $OutputPath
  ```

- Create a package that will audit and apply the configuration (Set)

  ```PowerShell
  New-GuestConfigurationPackage `
  -Name 'AzureArcLevelUp_Windows' `
  -Configuration "$OutputPath/localhost.mof" `
  -Type AuditAndSet `
  -Path $OutputPath `
  -Force
  ```

- Test applying the configuration to the local machine

  ```PowerShell
  Start-GuestConfigurationPackageRemediation -Path "$OutputPath/AzureArcLevelUp_Windows.zip"
  ```

- Upload the configuration package to the Azure Storage Account.

  ```PowerShell
  $StorageAccount = Get-AzStorageAccount -Name "machineconfigstg$storageaccountsuffix" -ResourceGroupName $ResourceGroupName

  $StorageAccountKey = Get-AzStorageAccountKey -Name $storageaccount.StorageAccountName -ResourceGroupName $storageaccount.ResourceGroupName
  $Context = New-AzStorageContext -StorageAccountName $storageaccount.StorageAccountName -StorageAccountKey $StorageAccountKey[0].Value

  Set-AzStorageBlobContent -Container "machineconfiguration" -File  "$OutputPath/AzureArcLevelUp_Windows.zip" -Blob "AzureArcLevelUp_Windows.zip" -Context $Context -Force

  $contenturi = New-AzStorageBlobSASToken -Context $Context -FullUri -Container machineconfiguration -Blob "AzureArcLevelUp_Windows.zip" -Permission r
  ```

- Create an Azure Policy definition.

  ```PowerShell
  $PolicyId = (New-Guid).Guid

  New-GuestConfigurationPolicy `
    -PolicyId $PolicyId `
    -ContentUri $ContentUri `
    -DisplayName "(AzureArcJumpstart) [Windows] Custom configuration $storageaccountsuffix" `
    -Description "Azure Arc Jumpstart Windows demo configuration" `
    -Path  $OutputPath `
    -Platform "Windows" `
    -PolicyVersion 1.0.0 `
    -Mode ApplyAndAutoCorrect `
    -Verbose -OutVariable Policy

  $PolicyParameterObject = @{'IncludeArcMachines'='true'}

  New-AzPolicyDefinition -Name "(AzureArcJumpstart) [Windows] Custom config $storageaccountsuffix" -Policy $Policy.Path -OutVariable PolicyDefinition
  ```

- Assign the Azure Policy definition to the target resource group.

  ```PowerShell
  $ResourceGroup = Get-AzResourceGroup -Name $ResourceGroupName

  New-AzPolicyAssignment -Name "(AzureArcJumpstart) [Windows] Custom config $storageaccountsuffix" -PolicyDefinition $PolicyDefinition[0] -Scope $ResourceGroup.ResourceId -PolicyParameterObject $PolicyParameterObject -IdentityType SystemAssigned -Location $Location -DisplayName "(AzureArcJumpstart) [Windows] Custom config $storageaccountsuffix" -OutVariable PolicyAssignment
  ```

- In order for the newly assigned policy to remediate existing resources, the policy must be assigned a managed identity and a policy remediation must be performed.

  ```PowerShell
  $PolicyAssignment = Get-AzPolicyAssignment -PolicyDefinitionId $PolicyDefinition.PolicyDefinitionId | Where-Object Name -eq "(AzureArcJumpstart) [Windows] Custom config $storageaccountsuffix"

  $roleDefinitionIds =  $PolicyDefinition.Properties.policyRule.then.details.roleDefinitionIds

  # Wait for eventual consistency
  Start-Sleep 20

  if ($roleDefinitionIds.Count -gt 0)
   {
       $roleDefinitionIds | ForEach-Object {
           $roleDefId = $_.Split("/") | Select-Object -Last 1
           New-AzRoleAssignment -Scope $resourceGroup.ResourceId -ObjectId $PolicyAssignment.Identity.PrincipalId -RoleDefinitionId $roleDefId
       }
   }

   $job = Start-AzPolicyRemediation -AsJob -Name ($PolicyAssignment.PolicyAssignmentId -split '/')[-1] -PolicyAssignmentId $PolicyAssignment.PolicyAssignmentId -ResourceGroupName $ResourceGroup.ResourceGroupName -ResourceDiscoveryMode ReEvaluateCompliance
  ```

- To check policy compliance, in the Azure Portal, navigate to *Policy* -> *Compliance*

- Set the scope to the resource group your instance of ArcBox is deployed to

- Filter for *(AzureArcJumpstart) [Windows] Custom configuration*

    ![Screenshot of Azure Portal showing Azure Policy compliance](./portal_policy_compliance.png)

> **NOTE: It may take 15-20 minutes for the policy remediation to be completed.**

- To get a Machine Configuration status for a specific machine, navigate to _Azure Arc_ -> _Machines_

- Click on ArcBox-Win2K22 -> Machine Configuration

- If the status for _ArcBox-Win2K22/AzureArcLevelUp_Windows_ is not _Compliant_, wait a few more minutes and click *Refresh*

    ![Screenshot of Azure Portal showing Azure Machine Configuration compliance](./portal_machine_config_compliance.png)

- Click on _ArcBox-Win2K22/AzureArcLevelUp_Windows_ to get a per-resource view of the compliance state in the assigned configuration

    ![Screenshot of Azure Portal showing Azure Machine Configuration compliance detailed view](./portal_machine_config_configs.png)

##### Verify that the operating system level settings are in place

- To verify that the operating system level settings are in place, run the following commands:

  ```powershell
  Write-Host "Creating VM Credentials"
  $nestedWindowsUsername = "Administrator"
  $secWindowsPassword = ConvertTo-SecureString $nestedWindowsPassword -AsPlainText -Force
  $winCreds = New-Object System.Management.Automation.PSCredential ($nestedWindowsUsername, $secWindowsPassword)

  Invoke-Command -VMName $Win2k19vmName -ScriptBlock { Get-LocalUser -Name arcboxuser1 } -Credential $winCreds
  Invoke-Command -VMName $Win2k19vmName -ScriptBlock {  Get-WindowsFeature -Name FS-SMB1 | select  DisplayName,Installed,InstallState} -Credential $winCreds
  ```

  ![Screenshot of VScode showing Azure Machine Configuration validation on Windows](./vscode_win_machine_config_validation.png)


### Module 8: Query and inventory your Azure Arc-enabled servers using Azure resource graph

#### Module overview

In this module, you will learn how to use the Azure Resource queries both in the Azure Graph Explorer and Powershell to demonstrate inventory management of your Azure Arc connected servers. Note that the results you get by running the graph queries in this module might be different from the sample screenshots as your environment might be different e.g. as a result of working with the other modules.

#### Task 1: Apply resource tags to Azure Arc-enabled servers

In this first step, you will assign Azure resource tags to some of your Azure Arc-enabled servers. This gives you the ability to easily organize and manage server inventory.

- Enter "Machines - Azure Arc" in the top search bar in the Azure portal and select it from the displayed services.

    ![Screenshot showing how to display Arc connected servers in portal](./Arc_servers_search.png)

- Click on any of your Azure Arc-enabled servers.

    ![Screenshot showing existing Arc connected servers](./click_on_any_arc_enabled_server.png)

- Click on "Tags". Add a new tag with Name="Scenario” and Value="azure_arc_servers_inventory”. Click Apply when ready.

    ![Screenshot showing adding tag to a server](./tagging_servers.png)

- Repeat the same process in other Azure Arc-enabled servers if you wish. This new tag will be used later when working with Resource Graph Explorer queries.

#### Task 2: The Azure Resource Graph Explorer

- Now we will explore our hybrid server inventory using a number of Azure Graph Queries. Enter "Resource Graph Explorer" in the top search bar in the Azure portal and select it.

    ![Screenshot of Graph Explorer in portal](./search_graph_explorer.png)

- The scope of the Resource Graph Explorer can be set as seen below

    ![Screenshot of Graph Explorer Scope](./Scope_of_Graph_Query.png)

#### Task 3: Run a query to show all Azure Arc-enabled servers in your subscription

- In the query window, enter and run the following query and examine the results which should show your Arc-enabled servers. Note the use of the KQL equals operator (=~) which is case insensitive [KQL =~ (equals) operator](https://learn.microsoft.com/azure/data-explorer/kusto/query/equals-operator).

  ```shell
  Resources
  | where type =~ 'Microsoft.HybridCompute/machines'
  ```

  ![Screenshot of query to list arc servers](./query_arc_machines.png)

- Scroll to the right on the results pane and click "See Details" to see all the Azure Arc-enabled server metadata. Note for example the list of detected properties, we will be using these in the next task.

- You can also run the same query using PowerShell (e.g. using Azure Cloud Shell) providing that you have added the required module "Az.ResourceGraph" as explained in [Run your first Resource Graph query using Azure PowerShell](https://learn.microsoft.com/azure/governance/resource-graph/first-query-powershell#add-the-resource-graph-module).

To install the PowerShell module, run the following command

  ```powershell
  Install-Module -Name Az.ResourceGraph
  ```

Then run the query in PowerShell

  ```powershell
   Search-AzGraph -Query "Resources | where type =~ 'Microsoft.HybridCompute/machines'"
  ```

#### Task 4: Query your server inventory using the available metadata

- Use PowerShell and the Resource Graph Explorer to summarize the server count by "logical cores" which is one of the detected properties referred to in the previous task. Remember to only use the query string, which is enclosed in double quotes, in the portal.

  ```powershell
  Search-AzGraph -Query  "Resources
  | where type =~ 'Microsoft.HybridCompute/machines'
  | extend logicalCores = tostring(properties.detectedProperties.logicalCoreCount)
  | summarize serversCount = count() by logicalCores"
  ```

- The Graph Explorer allows you to get a graphical view of your results by selecting the "charts" option.

    ![Screenshot of the logicalCores server summary](./chart_for_vcpu_summay.png)

#### Task 5: Use the resource tags in your Graph Query.

- Let’s now build a query that uses the tag we assigned earlier to some of our Azure Arc-enabled servers. Use the following query that includes a check for resources that have a value for the Scenario tag. Feel free to use the portal of PowerShell. Check that the results match the servers that you set tags for earlier.

  ```powershell
  Search-AzGraph -Query  "Resources
  | where type =~ 'Microsoft.HybridCompute/machines' and isnotempty(tags['Scenario'])
  | extend Scenario = tags['Scenario']
  | project name, tags"
  ```

#### Task 6: List the extensions installed on the Azure Arc-enabled servers.

- Run the following advanced query which allows you to see what extensions are installed on the Arc-enabled servers. Notice that running the query in PowerShell requires us to escape the $ character as explained in [Escape Characters](https://learn.microsoft.com/azure/governance/resource-graph/concepts/query-language#escape-characters)

  ```powershell
  Search-AzGraph -Query "Resources
  | where type == 'microsoft.hybridcompute/machines'
  | project id, JoinID = toupper(id), ComputerName = tostring(properties.osProfile.computerName), OSName = tostring(properties.osName)
  | join kind=leftouter(
      Resources
      | where type == 'microsoft.hybridcompute/machines/extensions'
      | project MachineId = toupper(substring(id, 0, indexof(id, '/extensions'))), ExtensionName = name
  ) on `$left.JoinID == `$right.MachineId
  | summarize Extensions = make_list(ExtensionName) by id, ComputerName, OSName
  | order by tolower(OSName) desc"
  ```

- If you have used the portal to run the query then you should see something like the following

    ![Screenshot of extensions query](./Extensions_query.png)

#### Task 7: Query other properties

- Azure Arc provides additional properties on the Azure Arc-enabled server resource that we can query with Resource Graph Explorer. In the following example, we list some of these key properties, like the Azure Arc Agent version installed on your Azure Arc-enabled servers

  ```powershell
  Search-AzGraph -Query  "Resources
  | where type =~ 'Microsoft.HybridCompute/machines'
  | extend arcAgentVersion = tostring(properties.['agentVersion']), osName = tostring(properties.['osName']), osVersion = tostring(properties.['osVersion']), osSku = tostring(properties.['osSku']),
  lastStatusChange = tostring(properties.['lastStatusChange'])
  | project name, arcAgentVersion, osName, osVersion, osSku, lastStatusChange"
  ```

- Running the same query in the portal should result in something like the following

    ![Screenshot of extra properties](./extra_properties.png)

### Module 9: Enforce governance across your Azure Arc-enabled servers using Azure Policy

#### Module overview

In this module you will use Azure Policy to Audit Arc-enabled Linux servers that have a certain application installed

#### Task 1: Assign a built-in Azure Policy to the Arc resource group

- Azure policy can be assigned at Management Group, Subscription or Resource Group scope. In this scenario we will use the Resource Group scope.
- We will show two ways to accomplish this first task. **First we will use the Azure portal** (but if you prefer to use Powershell then skip to that section at the end of this first task)
- In the Azure Portal search for the "Policy" resource and navigate to it.
- Click on "Compliance" in the left mene then click "Assign policy".

    ![Screenshot Navigate to policy assignment](./navigate_to_Policy_initiatives.png)

- Set the scope of the policy assignment to the subscription and the resource group as shown below

    ![Screenshot set Scope of policy](./choose_sub_RG.png)

- Click on the ellipsis next to "Policy definition". This opens the "Available Definitions" panel, where you can start searching for "Audit Linux machines that have the specific applications installed" policy which belongs to the "Guest Configuration" category. Select this policy as shown below.

    ![Screen shot select audit policy](./find_Linux_policy.png)

- Modify the "Assignment name" so that it would be easy to identify our policy in the compliance list later as shown below, then click "Next" twice to reach the "Parameters" tab.

    ![Screenshot change assignment name](./change_assignment_name.png)

- On the "Parameters" Screen, set the "Include Arc connected servers" to "true" and then set the name/s of the applications you want to audit the Linux servers for. If you have more than one application then include them in a semicolon separated list enclosed in single quotes e.g. 'App1; App2; App3'.

    ![Screenshot Arc_Nano](./Arc_Nano.png)

- Move to the "Non-compliance message" tab to add a message of your choice.

    ![Screenshot non-compliance message](./Non_compliance_message.png)

- Next move to the "Review + create" tab and click "Create" to assign the policy.

- If you want to use **Powershell as an alternative method** to assign the policy, then the following procedure accomplishes the same as the portal method explained above.
    - create a policy parameter file, e.g. parameters.json

      ```javascript
      {
        "IncludeArcMachines":{
          "value":"true"
        },
        "ApplicationName": {
          "value":"nano"
        }
      }
      ```

    - Run the following powershell commands

      ```powershell
      $ResourceGroup = Get-AzResourceGroup -Name 'ArcBox-Levelup'
      $Policy = Get-AzPolicyDefinition -BuiltIn | Where-Object {$_.Properties.DisplayName -eq 'Audit Linux machines that have the specified applications installed'}
      New-AzPolicyAssignment -Name '(Arc Levelup) Audit Linux machines with python3 installed' -PolicyDefinition $Policy -Scope $ResourceGroup.ResourceId -PolicyParameter .\parameters.json
      ```

#### Task 2: Examine the policy compliance

- The creation of the assignment and for it to take effect and get evaluated might take some time. You can keep refreshing the "Compliance" list until you can see an indication that there is at least one resource which is non-compliant with the policy we created (this depends on how many Arc-connected Linux servers with the specified applications we have). **If this does not happen in a reasonable time then go to task 3 where there is another view that might faster to show the compliance indication**. We can also attempt to force a policy scan (see note at end of this task) which **might** improve the speed to populate the compliance dashboard.

    ![Screenshot of policies and their compliances with the new policy](./Compliance_dashboard.png)

- Click on the policy from the name column and this will take you to a more detailed view of the specific policy compliance as shown below. You can then click on "details" which will open another panel on the right hand side. **If the "details" link is not ready yet then you will need to wait for it, or try task 3 for another way of looking at the compliance of specific servers, which might be faster to populate.**

    ![Screenshot detailed compliance](./detailed_compliance.png)

- Click on the link below "Last evaluated resource ...". This will open the "Guest Assignment" screen showing exactly why that specific server is not compliant with the policy.

    ![Screenshot Guest Assignment from details](./Guest_assignment_from_details.png)

- The steps above helps you identify non-compliant resources and then you can act on resolving the non-compliance reasons.

- NOTE (Optional): As mentioned at the beginning of this task, to force a policy scan we can use the [Start-AzPolicyComplianceScan powershell command](https://learn.microsoft.com/powershell/module/az.policyinsights/start-azpolicycompliancescan?view=azps-10.2.0). For example the following Powershell commands will focus the scan on our resource group, run the scan as a job and wait for it to complete in the background:

  ```powershell
  $job = Start-AzPolicyComplianceScan  -ResourceGroupName "ArcBox-Levelup" -AsJob
  $job | Wait-Job
  ```

#### Task 3: Using the "Guest Assignments" views directly

- As mentioned in Task 2, the policy compliance dashboard can sometimes take a long time before it is updated with the accurate compliance details. We can use a direct route to view the "Guest Assignments" for each resource by searching for "Guest Assignments" from the Azure portal and selecting it.

    ![Screenshot search for guest assignments](./search_for_guest_assignments.png)

- You can now look at the compliance of the individual resources and identify the ones that are affected by our policy assignment.

    ![Screenshot Guest Assignment details](./Guest_Assignment_Details.png)

- Click on the identified policy/resource combination and this will take you to the screen that we saw earlier at the end of Task 2, showing the details of the compliance/non-compliance.

