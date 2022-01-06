1. Run Poweshell as Admin
2. paste in this command to allow running scripts by modifying Execution policy.

$ npm install --save copy

Set-ExecutionPolicy -ExecutionPolicy Bypass -Force ; .\get-sys-info.ps1