Import-Module ActiveDirectory

$groupspath  = ".\groups.csv"
$groups     = @()
$groups     = Import-Csv -Path $groupspath
# Loop through Groups CSV
ForEach ($grp In $groups)
{
  Try
  {
    # Check if the Group already exists
    $exists = Get-ADGroup $grp.Name
    Write-Host "Group $($grp.Name) alread exists!!!"
  }
  Catch
  {
    # Create the group if it doesn't exist
    $create = New-ADGroup -Name $grp.Name -GroupScope $grp.GroupScope
    Write-Host "Group $($grp.Name) created!"
  }
}


$usersspath  = ".\users.csv"
$users     = @()
$users     = Import-Csv -Path $usersspath
$Password = read-host "Enter the Password for all users:" -assecurestring

# Loop through Users CSV
ForEach ($usr In $users)
{
  $lastname= $usr.Surname
  $Detailedname = $usr.Name
  $UserFirstname = $usr.GivenName
  $SAM =  $usr.SamAccountName
  $UPN= $usr.UserPrincipalName
  $group= $usr.Group
  Try
  {
    # Check if the user already exists
    $exists = Get-ADUser $usr.SamAccountName
    Write-Host "User $($usr.SamAccountName) alread exists!!!"
  }
  Catch
  {
    # Create the user if it doesn't exist
    $create = New-ADUser -Name $Detailedname -SamAccountName $SAM -UserPrincipalName $UPN -GivenName $UserFirstname -Surname $lastname -AccountPassword $Password -Enabled $true  -ChangePasswordAtLogon $False
    Write-Host "User $($usr.SamAccountName) created!"
  }

  # Adding User to Group
  Add-ADPrincipalGroupMembership -Identity $SAM -MemberOf $group
}
