> [!IMPORTANT]
> 
> See powershell notification system for more information (https://docs.helloid.com/en/provisioning/notifications--provisioning-/notification-systems--provisioning-/powershell-notification-systems--provisioning-.html)
> 
| :information_source: Information |
|:---------------------------|
| This repository contains the connector and configuration code only. The implementer is responsible to acquire the connection details such as username, password, certificate, etc. You might even need to sign a contract or agreement with the supplier before implementing this connector. Please contact the client's application manager to coordinate the connector requirements.       |
<br />
<p align="center">
  <img src="#Zivver logo placeholder">
</p>

## Versioning
| Version | Description | Date |
| - | - | - |
| 1.0.0   | Initial release | 2023/06/20  |

<!-- TABLE OF CONTENTS -->
## Table of Contents
- [Versioning](#versioning)
- [Table of Contents](#table-of-contents)
- [Introduction](#introduction)
- [Setting up prerequisites](#Setting-up-prerequisites)
- [Connection settings](#connection-settings)
- [Remarks](#remarks)
- [Getting help](#getting-help)
- [HelloID Docs](#helloid-docs)

## Introduction
The interface to communicate with Zivver is standard SMTP.

For this connector we have to connect to the on-premise Agent to be able to send notifications over Zivver SMTP.

<!-- GETTING STARTED -->
## Setting up prerequisites
Setting up Zivver notifications is relatively easy. Zivvers DNS settings for the SMTP server must be configured and accessible from the agent server
Currently we only need user credentials 

* Currently we only need user credentials. Make sure that this is an SMTP user in Zivver, with a GUID-like username.

Additionally, we can send an extra phonenumber header for using SMS authentication. In this case we also need a source field where phonenumber should be mapped as '+31612345678'

## Connection settings
The following settings are required to connect to the API.

| Setting     | Description |
| ------------ | ----------- |
| Username | Zivver SMTP user |
| Password | Password |


## Remarks
- 

## Getting help
> _For more information on how to configure a HelloID PowerShell connector, please refer to our [documentation](https://docs.helloid.com/hc/en-us/articles/360012518799-How-to-add-a-target-system) pages_

> _If you need help, feel free to ask questions on our [forum](https://forum.helloid.com)_

## HelloID Docs
The official HelloID documentation can be found at: https://docs.helloid.com/
