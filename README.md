# PasswordGenerator
Generate a random password containing a mix of characters and symbols.
If used with no arguments it will generate a single 10 character password.

Accepts command line arguments:
PasswordLength - int - how long the password should be (minimum 5).
Admin - switch - generates a longer (20 character) password for admin accounts
Bulk - int - generate this many passwords in bulk
Stats - switch - show a little summary at the end

Note that TargetLength overrules Admin.

Examples:
Generate a single 15 character password:
  PasswordGenerator.ps1 -PasswordLength 15
  
  uWa+99!BM.X?5?7

Generate 3 admin passwords, and show stats:
  PasswordGenerator.ps1 -Admin -Bulk 3 -Stats
  
  H1?C1mtav77X.C6mH8j6
  8+xQ?xB53YK8U!E.NBk7
  -.61?!6K!mjm9fFs.r5y
  Generated 3 20 character passwords in 0.003 seconds. Current config entropy 120 bits

Generate 10 passwords and pipe into a file
  PasswordGenerator.ps1 -Bulk 10 | out-file "C:\example\passwords.txt"
