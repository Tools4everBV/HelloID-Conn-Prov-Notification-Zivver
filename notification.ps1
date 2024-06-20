#####################################################
# HelloID-Conn-Prov-Notification-Zivver
#
# Version: 1.0.0
#####################################################

# Initialize default values
$success = $false

# Enable TLS1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

# Set debug logging
switch ($($actionContext.Configuration.IsDebug)) {
    $true { $VerbosePreference = 'Continue' }
    $false { $VerbosePreference = 'SilentlyContinue' }
}

# Debug
<#

#$actionContext.DryRun = $false
$actionContext.TemplateConfiguration.From = ''
$actionContext.TemplateConfiguration.To = ''
$actionContext.TemplateConfiguration.PhoneNumber = ''
$actionContext.TemplateConfiguration.Subject = "Welkom!"
$actionContext.TemplateConfiguration.BodyContent = ''
$actionContext.TemplateConfiguration.HTML = $true

#>

#region functions
#end

try {
    # Setup Mail message
    $Message = New-object Net.Mail.MailMessage;

    $Message.From = $($actionContext.TemplateConfiguration.From);
    
    #For now only 1 person but should be easy to be able to send to multiple
    if( $($actionContext.TemplateConfiguration.PhoneNumber) ){
        Write-Verbose "Sending notification with SMS verification"
        $Message.To.Add($($actionContext.TemplateConfiguration.To));
        $Message.Headers.Add("zivver-access-right", "$($actionContext.TemplateConfiguration.To) sms $($actionContext.TemplateConfiguration.PhoneNumber)");
    } else {
        Write-Verbose "Sending notification without SMS verification"
        $Message.To.Add($($actionContext.TemplateConfiguration.To));
    }

     
    $Message.Subject = $($actionContext.TemplateConfiguration.Subject);
    $Message.Body = $($actionContext.TemplateConfiguration.BodyContent);
    $Message.IsBodyHtml = $($actionContext.TemplateConfiguration.HTML);   

    if (-Not($actionContext.DryRun -eq $true)) {
        Write-Verbose "Sending notification for: [$($personContext.Person.DisplayName)]"

        $SMTPClient = New-object Net.Mail.SmtpClient("smtp.zivver.com", "587");    
        $SMTPClient.EnableSSL = $true;
        $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($($actionContext.Configuration.Username) , $($actionContext.Configuration.Password));
        
        $SMTPClient.Send($message);

        $outputContext.AuditLogs.Add([PSCustomObject]@{
            Message = "Sending notification for [$($personContext.Person.DisplayName)] was successful."
            IsError = $false
        })
    } else {
        # Add an auditMessage showing what will happen during enforcement
        $outputContext.AuditLogs.Add([PSCustomObject]@{
                Message = "Sending notification for: [$($personContext.Person.DisplayName)], will be executed during enforcement"
            })
    }
}
    
catch {
    $ex = $PSItem
    
    switch ($ex.Exception.Message) {
        
        default {
            #Write-Verbose ($ex | ConvertTo-Json) # Debug - Test
            if ($($ex.Exception.GetType().FullName -eq 'Microsoft.PowerShell.Commands.HttpResponseException') -or
                $($ex.Exception.GetType().FullName -eq 'System.Net.WebException')) {
                $errorMessage = "Could not send Zivver notification for: [$($personContext.Person.DisplayName)]. Error: $($ex.ErrorDetails.Message)"
            }
            else {
                $errorMessage = "Could not send Zivver notification for: [$($personContext.Person.DisplayName)]. Error: $($ex.Exception.Message) $($ex.ScriptStackTrace)"
            } 
            $outputContext.AuditLogs.Add([PSCustomObject]@{
                    Message = $errorMessage
                    IsError = $true
                })
        }
    }
    # End
}

finally {
    # Check if auditLogs contains errors, if no errors are found, set success to true
    if (-NOT($outputContext.AuditLogs.isError -contains $true)) {
        $success = $true
    }
    $outputContext.Success = $success
}