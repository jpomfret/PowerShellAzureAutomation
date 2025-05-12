- demo where the error message is not good
  - thinking about client I where we tried to run aks command and one of the variables was empty - then I tried to compare and got a rubbish error
    ```
 [91mWrite-Error: [91mFailed to process AKS command: Command encountered an issue[0m [91mException: [0mC:\usr\src\tmp\6b9f1a9a-452d-411f-9205-e3e9be92131e\runbooks\DevOps-CreateTicket-Test-JP.ps1:65 [96mLine | [96m 65 | [0m [96mthrow "Command encountered an issue"[0m [96m | [91m ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ [91m[96m | [91mCommand encountered an issue [0m
    ```
  - then we can debug locally and step through it

