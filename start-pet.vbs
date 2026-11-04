' Start the desktop pet with no console window (log goes to logs\pet.log)
Set fso = CreateObject("Scripting.FileSystemObject")
root = fso.GetParentFolderName(WScript.ScriptFullName)
Set sh = CreateObject("WScript.Shell")
sh.CurrentDirectory = root
sh.Run "cmd /c """ & root & "\start-pet-hidden.cmd""", 0, False
