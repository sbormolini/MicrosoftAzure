<#
    .Synopsis
    AadGuestUser class
    .DESCRIPTION
    AadGuestUser class for Azure Ad Guest Managament
    .EXAMPLE
    $guest = [AadGuestUser]::new(
        "StorageAccountName"  
    )
#>

class AadGuestUser
{
    # table related
    [guid] $Id
    [string] $Status
    [string] $PartitionKey
    [string] $RowKey
    [string] $Info

    # invitation related
    [string] $RedirectUrl
    [string] $PersonalMessage
    [datetime] $InvitationDate

    # user related
    [string] $Name
    [string] $EmailAddress
    [string] $FirstName
    [string] $LastName  
    [string[]] $Groups
    [string[]] $Roles
    [bool] $BlockSignIn 
    [string] $JobTitle
    [string] $Department
    [string] $Company
    [object] $Manager # string or object?

    AadGuestUser(
        [string] $EmailAddress,
        [string] $FirstName,
        [string] $LastName,
        [string[]] $Groups,
        [string[]] $Roles,
        [bool] $BlockSignIn,
        [string] $JobTitle,
        [string] $Department,
        [string] $Company,
        [string] $Manager,
        [string] $RedirectUrl,
        [string] $PersonalMessage
    )
    {
        # set members
        $this.Id = [guid]::new()
        $this.Status = "InProgress"
        $this.PartitionKey = (Get-Date -Format yyyyMMdd)
        $this.RowKey = [string]($Manager.Split(' ')[0][0..1] + $Manager.Split(' ')[1][0..1] -join '').ToUpper()
     
        $this.RedirectUrl = $RedirectUrl
        $this.PersonalMessage = $PersonalMessage
        $this.InvitationDate = Get-Date -AsUTC

        $this.Name = $FirstName + ' ' + $LastName 
        $this.EmailAddress = $EmailAddress
        $this.FirstName = $FirstName 
        $this.LastName = $LastName
        $this.Groups = $Groups
        $this.Roles = $Roles
        $this.BlockSignIn = $BlockSignIn
        $this.JobTitle = $JobTitle
        $this.Department = $Department
        $this.Company = $Company
        $this.Manager = $Manager
    }

    [PSCustomObject] ToInvitationRequestBody()
    {
        return [PSCustomObject]@{
            invitedUserDisplayName = $this.Name
            invitedUserEmailAddress = $this.EmailAddress
            #invitedUserMessageInfo = {"@odata.type": "microsoft.graph.invitedUserMessageInfo"}
            sendInvitationMessage = $this.PersonalMessage ? $true : $false
            inviteRedirectUrl = $this.RedirectUrl
            #inviteRedeemUrl = "string"
            #resetRedemption = $false
            #status = "InProgress" # PendingAcceptance, Completed, InProgress, and Error
            #invitedUser = {"@odata.type": "microsoft.graph.user"}
            invitedUserType = "Guest" # Guest, Member
        }
    }

    [hashtable] ToTableEntity()
    {
        return [hashtable]@{
    
        }
    }
}
