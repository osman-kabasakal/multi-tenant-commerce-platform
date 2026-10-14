using Grand.Domain;
using System;

namespace Authentication.Keycloak.Domains;

public class InstalledPlugin: BaseEntity
{
    public string SystemName { get; set; }

    public string Version { get; set; }
}
