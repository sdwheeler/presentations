<!--
Title: Rapidly and securely manage your resources with Azure Cloud Shell
Presenters: Steven Judd and Jason Helmick
Description: Azure Cloud Shell is an interactive, authenticated, browser-accessible terminal for managing Azure resources. As a web-based environment, Cloud Shell provides immediate management access from any device with a network connection. Cloud Shell provides access to a range of shells/tools including bash, PowerShell, Azure PowerShell, and Azure CLI.
Join Azure Cloud Shell PM Jason Helmick and Shell Expert Steven Judd to quickly manage resources in the cloud and on-premises with Cloud Shell's "always-up-to-date" tools - and more!

-->

# Rapidly and securely manage your resources with Azure Cloud Shell

A Place for Demo notes and setup requirements.

- Arrive - April 11th 11:00am - Room 404
- Check the room

Doc set: https://learn.microsoft.com/azure/cloud-shell/overview

Laptop goal: 2 laptops

Steven demos
- ? Can you do some thing with Coud Shell? once we have it goes?  I dunno, make a vm or somethign interesting :)
- Demo...about why changing to the cloud drive is important for storing your files.
- Have predicotrs enabled.
Jason demos
- Getting started (With ephemeral/storage account)
- VNET, VNET fast. (have a failover)
- ? Docker image (local cloud shell)

## Introduction

- Our introduction

## Welcome to Azure Cloud Shell (10)

- Welcome to Azure Cloud Shell
  - Azure Cloud Shell is ... is an interactive, authenticated, browser-accessible shell for managing Azure resources.
  - It is ALSO: (Try to show these)
    - Available in VSCode (Azure.Accounts extension) - Demo
    - Available in The NEw and Awesome Windows Terminal -Demo
    - (Save this for below) Available in the Azure Mobile App
    - OFten seen on MSLearn
    - Available locally :)
- Azure Cloud Shell is a container
  - Originally two containers, one linux, one Windows - PowerShell is cross platform, so for better performance, linux today.
  - Azure Linux (Mariner) container - Two Shell flavors - Bash and PowerShell.
- Tooling and Updates
  - Azure Cloud Shell includes tools for bash and Powershell to manage Azure resources
  - tdnf or Get-PackageVersion
  - Examples: AZ CLI, Azure PowerShell, Terriform.
  - Updates occur monthly :)

## How to get started using Cloud Shell (Jason demo's) (10)

- Connecting for the first time.
- Default: Ephemeral
  - Doc: https://learn.microsoft.com/azure/cloud-shell/get-started/ephemeral?tabs=azurecli
- New Storage account
  - Doc: https://learn.microsoft.com/azure/cloud-shell/get-started/new-storage?tabs=azurecli
- Existing Storage account
  - Doc: https://learn.microsoft.com/azure/cloud-shell/get-started/existing-storage?tabs=azurecli

## Using Azure Cloud Shell( Steven Demo's) (10)

- Introducing the toolbar (Just give them the doc - no conversation)
  - Doc: https://learn.microsoft.com/azure/cloud-shell/new-ui-shell-window
- Working with the cloud drive and your storage
- USing CoPilot with Azure Cloud Shell
  - Managing Azure resources (maybe create a vm?)

## Enterprise - Azure Cloud Shell VNET(Jason Demo) (5-10)

- Why use VNET isolation
- Doc: https://learn.microsoft.com/azure/cloud-shell/vnet/deployment
- Doc: TRoubleshooting: https://learn.microsoft.com/azure/cloud-shell/vnet/troubleshooting


## Running Cloud Shell locally (JAson) (5-10) Cloud Shell Anywhere (Everywhere)

- Benefit -- "Ready for Service"
- Source documentation - and everything you need: https://github.com/Azure/CloudShell
- Show docker run
- Show local shell
  - Connect to Azure
  - Access local script (local file access) -- maybe local server (non-Arch enabled)
- Great Artcile: https://powershellisfun.com/2024/02/16/running-azure-cloud-shell-locally-using-docker/

- Can we Add the mobile App here --- cloud shell everywhere.

## Enterprise concerns (need better title) (Just a slide on the summary

- Storage account name and location
- Sharing storage accounts
- Premium storage versus standard
- Backups
- Security
- Logging

$$ Xtra Credit
- Slide that contains -
- Can we show the mobile app?  one more thing......
