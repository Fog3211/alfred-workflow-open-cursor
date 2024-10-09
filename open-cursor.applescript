on alfred_script(q)

set finderSelection to ""
set theTarget to ""
set appPath to path to application "Cursor"
set defaultTarget to (path to home folder as alias)

-- Check if Cursor application exists
if not (exists file appPath) then
    display dialog "Cursor application not found. Please make sure Cursor is properly installed." buttons {"OK"} default button 1 with icon stop
    return
end if

if (q as string) is "" then
    tell application "Finder"
        try
            set finderSelection to (get selection)
            if length of finderSelection is greater than 0 then
                set theTarget to finderSelection
            else
                try
                    set theTarget to (folder of the front window as alias)
                on error
                    set theTarget to defaultTarget
                end try
            end if

            open theTarget using appPath
        on error errMsg
            display dialog "Error opening target: " & errMsg buttons {"OK"} default button 1 with icon stop
        end try
    end tell
else
    try
        set targets to {}
        set oldDelimiters to text item delimiters
        set text item delimiters to tab
        set qArray to every text item of q
        set text item delimiters to oldDelimiters
        repeat with atarget in qArray

            if atarget starts with "~" then
                set userHome to POSIX path of (path to home folder)
                if userHome ends with "/" then
                    set userHome to characters 1 thru -2 of userHome as string
                end if

                try
                    set atarget to userHome & characters 2 thru -1 of atarget as string
                on error
                    set atarget to userHome
                end try

            end if

            try
                set targetAlias to ((POSIX file atarget) as alias)
                set targets to targets & targetAlias
            on error
                display dialog "Unable to access path: " & atarget & ". Please check if the path is correct and you have the necessary permissions." buttons {"OK"} default button 1 with icon stop
                return
            end try
        end repeat

        set theTarget to targets

        tell application "Finder"
            open theTarget using appPath
        end tell
    on error errMsg
        display dialog "Error processing path: " & errMsg buttons {"OK"} default button 1 with icon stop
    end try
end if


end alfred_script