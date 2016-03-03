tosca_definitions_version: tosca_simple_yaml_1_0

# Note: Tosca derived_from isn't working the way I think it should, it's not
#    inheriting from the parent template. Until we get that figured out, use
#    m4 macros do our inheritance

define(xos_base_props,
            no-delete:
                type: boolean
                default: false
                description: Do not allow Tosca to delete this object
            no-create:
                type: boolean
                default: false
                description: Do not allow Tosca to create this object
            no-update:
                type: boolean
                default: false
                description: Do not allow Tosca to update this object)
# Service
define(xos_base_service_caps,
            scalable:
                type: tosca.capabilities.Scalable
            service:
                type: tosca.capabilities.xos.Service)
define(xos_base_service_props,
            kind:
                type: string
                default: generic
                description: Type of service.
            view_url:
                type: string
                required: false
                description: URL to follow when icon is clicked in the Service Directory.
            icon_url:
                type: string
                required: false
                description: ICON to display in the Service Directory.
            enabled:
                type: boolean
                default: true
            published:
                type: boolean
                default: true
                description: If True then display this Service in the Service Directory.
            public_key:
                type: string
                required: false
                description: Public key to install into Instances to allows Services to SSH into them.
            private_key_fn:
                type: string
                required: false
                description: Location of private key file
            versionNumber:
                type: string
                required: false
                description: Version number of Service.)
# Subscriber
define(xos_base_subscriber_caps,
            subscriber:
                type: tosca.capabilities.xos.Subscriber)
define(xos_base_subscriber_props,
            kind:
                type: string
                default: generic
                description: Kind of subscriber
            service_specific_id:
                type: string
                required: false
                description: Service specific ID opaque to XOS but meaningful to service)
define(xos_base_tenant_props,
            kind:
                type: string
                default: generic
                description: Kind of tenant
            service_specific_id:
                type: string
                required: false
                description: Service specific ID opaque to XOS but meaningful to service)

# end m4 macros
#
# compile this with "m4 custom_types/xos.m4 > custom_types/xos.yaml"

node_types:
    tosca.nodes.Service:
        derived_from: tosca.nodes.Root
        description: >
            An XOS Service object. Services may be listed in the Service
            directory and may be linked together via Tenancy Relationships.
        capabilities:
            xos_base_service_caps
        properties:
            xos_base_props
            xos_base_service_props

    tosca.nodes.Tenant:
        derived_from: tosca.nodes.Root
        description: >
            An ONOS Tenant.
        properties:
            xos_base_tenant_props
            service_specific_attribute:
                type: string
                required: false
                description: Service-specific attribute, usually a string containing a json dictionary
            model:
                type: string
                required: false
                description: Name of model to use when instantiating tenant

    tosca.nodes.ONOSService:
        derived_from: tosca.nodes.Root
        description: >
            ONOS Service
        capabilities:
            xos_base_service_caps
        properties:
            xos_base_props
            xos_base_service_props
            rest_onos/v1/network/configuration/:
                type: string
                required: false
            rest_hostname:
                type: string
                required: false
            rest_port:
                type: string
                required: false
            no_container:
                type: boolean
                default: false


    tosca.nodes.ONOSApp:
        derived_from: tosca.nodes.Root
        description: >
            An ONOS Application.
        properties:
            xos_base_tenant_props
            dependencies:
                type: string
                required: false

    tosca.nodes.ONOSvBNGApp:
        derived_from: tosca.nodes.Root
        description: >
            An ONOS vBNG Application.
        properties:
            xos_base_tenant_props
            dependencies:
                type: string
                required: false
            install_dependencies:
                type: string
                required: false
            component_config:
                type: string
                required: false
            config_addresses.json:
                type: string
                required: false
            config_network-cfg.json:
                type: string
                required: false
            config_virtualbng.json:
                type: string
                required: false

    tosca.nodes.ONOSvOLTApp:
        derived_from: tosca.nodes.Root
        description: >
            An ONOS vOLT Application.
        properties:
            xos_base_tenant_props
            dependencies:
                type: string
                required: false
            install_dependencies:
                type: string
                required: false
            component_config:
                type: string
                required: false
            config_network-cfg.json:
                type: string
                required: false
            rest_onos/v1/network/configuration/:
                type: string
                required: false

    tosca.nodes.ONOSVTNApp:
        derived_from: tosca.nodes.Root
        description: >
            An ONOS VTN Application.
        properties:
            xos_base_tenant_props
            dependencies:
                type: string
                required: false
            rest_onos/v1/network/configuration/:
                type: string
                required: false

    tosca.nodes.VCPEService:
        description: >
            CORD: The vCPE Service.
        derived_from: tosca.nodes.Root
        capabilities:
            xos_base_service_caps
        properties:
            xos_base_props
            xos_base_service_props
            backend_network_label:
                type: string
                required: false
                description: Label that matches network used to connect HPC and BBS services.

    tosca.nodes.VBNGService:
        derived_from: tosca.nodes.Root
        description: >
            CORD: The vBNG Service.
        capabilities:
            xos_base_service_caps
        properties:
            xos_base_props
            xos_base_service_props
            vbng_url:
                type: string
                required: false
                description: URL of REST API endpoint for vBNG Service.

    tosca.nodes.CDNService:
        derived_from: tosca.nodes.Root
        description: >
            Content Delivery Network Service. Includes Request Routing and Hypercache.
        capabilities:
            xos_base_service_caps
        properties:
            xos_base_props
            xos_base_service_props

    tosca.nodes.Subscriber:
        derived_from: tosca.nodes.Root
        description: XOS subscriber base class.
        capabilities:
            xos_base_subscriber_caps
        properties:
            xos_base_subscriber_props

    tosca.nodes.CORDSubscriber:
        derived_from: tosca.nodes.Root
        description: >
            CORD: Subscriber. The Subscriber object contains all of the settings
            for a CORD household. For example, it contains parental control
            filter settings.
        capabilities:
            xos_base_subscriber_caps
        properties:
            xos_base_subscriber_props
            firewall_enable:
                type: boolean
                default: false
                description: If True, then firewalling is enabled.
            url_filter_enable:
                type: boolean
                default: false
                description: If True, then parental controls are enabled.
            url_filter_level:
                type: string
                default: PG
                description: The default URL filter level for the household.
            cdn_enable:
                type: boolean
                default: true
                description: If True, then the CDN is enabled.

    tosca.nodes.CORDUser:
        derived_from: tosca.nodes.Root
        description: >
            CORD: User. The CORD user represents an individual device beloning
            to the CORD Subscriber. Each device may have its own parental
            controls.
        capabilities:
            device:
                type: tosca.capabilities.xos.Device
        properties:
            level:
                type: string
                default: PG_13
                description: Parental control level for this device.
            mac:
                type: string
                required: true
                description: MAC address for this device.

    tosca.nodes.VOLTTenant:
        derived_from: tosca.nodes.Root
        description: >
            CORD: A Tenant of the vOLT Service. Each Tenant is tied to a
            specific vlan_id.
        properties:
            xos_base_tenant_props
            s_tag:
                type: string
                required: false
                description: s_tag, identifies which volt port
            c_tag:
                type: string
                required: false
                description: c_tag, identifies which subscriber within s_tag

    tosca.nodes.User:
        derived_from: tosca.nodes.Root

        description: >
            An XOS User record. Users are able to login and use the XOS GUI.

        capabilities:
            user:
                type: tosca.capabilities.xos.User

        properties:
            password:
                type: string
                required: false
            firstname:
                type: string
                required: true
                description: First name of User.
            lastname:
                type: string
                required: true
                description: Last name of User.
            phone:
                type: string
                required: false
                description: Phone number of User.
            user_url:
                type: string
                required: false
                description: URL to User web page.
            public_key:
                type: string
                required: false
                description: Public key that will be installed in Instances.
            is_active:
                type: boolean
                default: true
                description: If True, the user may log in.
            is_admin:
                type: boolean
                default: false
                description: If True, the user has root admin privileges.
            login_page:
                type: string
                required: false
                description: Indicates what page the user should go to on login.

    tosca.nodes.NetworkParameterType:
        derived_from: tosca.nodes.Root

        description: >
            An XOS network parameter type. May be applied to Networks and/or
            Ports.

        capabilities:
            network_parameter_type:
                type: tosca.capabilities.xos.NetworkParameterType

    tosca.nodes.NetworkTemplate:
        derived_from: tosca.nodes.Root

        description: >
            An XOS network template. Network templates contain settings associated
            with a particular class of network.

        capabilities:
            network_template:
                type: tosca.capabilities.xos.NetworkTemplate

        properties:
            visibility:
                type: string
                default: private
                description: Indicates whether network is publicly routable.
            translation:
                type: string
                default: none
                description: Indicates whether network uses address translation.
            shared_network_name:
                type: string
                required: false
                description: Attaches this template to a specific OpenStack network.
            shared_network_id:
                type: string
                required: false
                description: Attaches this template to a specific OpenStack network.
            topology_kind:
                type: string
                default: BigSwitch
                description: Describes the topology of the network.
            controller_kind:
                type: string
                required: false
                description: Indicates the type of controller that the network is connected to.
            access:
                type: string
                required: false
                description: The type of access semantics for this network

    tosca.nodes.network.Network.XOS:
          # Due to bug? in implementation, we have to copy everything from
          # tosca definitions tosca.nodes.network.Network here rather than
          # using derived_from.
          derived_from: tosca.nodes.Root
          description: >
            This is a variant of the TOSCA Network object that includes additional
            XOS-specific properties.
          properties:
            ip_version:
              type: integer
              required: no
              default: 4
              constraints:
                - valid_values: [ 4, 6 ]
              description: >
                The IP version of the requested network. Valid values are 4 for ipv4
                or 6 for ipv6.
            cidr:
              type: string
              required: no
              description: >
                The cidr block of the requested network.
            start_ip:
              type: string
              required: no
              description: >
                 The IP address to be used as the start of a pool of addresses within
                 the full IP range derived from the cidr block.
            end_ip:
              type: string
              required: no
              description: >
                  The IP address to be used as the end of a pool of addresses within
                  the full IP range derived from the cidr block.
            gateway_ip:
              type: string
              required: no
              description: >
                 The gateway IP address.
            network_name:
              type: string
              required: no
              description: >
                 An identifier that represents an existing Network instance in the
                 underlying cloud infrastructure or can be used as the name of the
                 newly created network. If network_name is provided and no other
                 properties are provided (with exception of network_id), then an
                 existing network instance will be used. If network_name is provided
                 alongside with more properties then a new network with this name will
                 be created.
            network_id:
              type: string
              required: no
              description: >
                 An identifier that represents an existing Network instance in the
                 underlying cloud infrastructure. This property is mutually exclusive
                 with all other properties except network_name. This can be used alone
                 or together with network_name to identify an existing network.
            segmentation_id:
              type: string
              required: no
              description: >
                 A segmentation identifier in the underlying cloud infrastructure.
                 E.g. VLAN ID, GRE tunnel ID, etc..
            dhcp_enabled:
              type: boolean
              required: no
              default: true
              description: >
                Indicates should DHCP service be enabled on the network or not.
        # XOS-specific
            ports:
                type: string
                required: false
                description: >
                    A comma-separated list of protocols and ports. For example,
                    "tcp/123, tcp/456-459, udp/111"
            labels:
                type: string
                required: false
                description: A comma-separated list of labels for this network.
            permit_all_slices:
                type: boolean
                # In the data model, this is defaulted to false. However, to
                # preserve Tosca semantics, we default it to true instead.
                default: true
                description: If True, then any slice may be attached to this network.
          capabilities:
            link:
              type: tosca.capabilities.network.Linkable

    tosca.nodes.Deployment:
        derived_from: tosca.nodes.Root
        description: >
            An XOS Deployment.
        capabilities:
            deployment:
                type: tosca.capabilities.xos.Deployment
        properties:
            xos_base_props
            accessControl:
                type: string
                default: allow all
                description: ACL that describes who may use this deployment.
            flavors:
                type: string
                required: false
                description: Comma-separated list of flavors that this deployment supports.

    tosca.nodes.Image:
        derived_from: tosca.nodes.Root
        description: >
            An XOS Operating System Image.
        capabilities:
            image:
                type: tosca.capabilities.xos.Image
        properties:
            kind:
                type: string
                required: false
                description: Type of image (container | VM)
            disk_format:
                type: string
                required: false
                description: Glance disk format.
            container_format:
                type: string
                required: false
                description: Glance container format.
            path:
                type: string
                required: false
                description: Path to Image file
            tag:
                type: string
                required: false
                description: For Docker images, tag of image

    tosca.nodes.Controller:
        derived_from: tosca.nodes.Root
        description: >
            An XOS controller. Controllers serve as the interface between
            XOS and services such as OpenStack.
        capabilities:
            controller:
                type: tosca.capabilities.xos.Controller
        properties:
            xos_base_props
            backend_type:
                type: string
                required: false
                description: Type of backend.
            version:
                type: string
                required: false
                description: Version of backend.
            auth_url:
                type: string
                required: false
                description: Keystone auth_url.
            admin_user:
                type: string
                required: false
                description: Keystone username.
            admin_password:
                type: string
                required: false
                description: Keystone password.
            admin_tenant:
                type: string
                required: false
                description: Tenant associated with admin account.
            domain:
                type: string
                required: false
                description: OpenStack domain (or "Default")
            rabbit_host:
                type: string
                required: false
                description: Rabbit host
            rabbit_user:
                type: string
                required: false
                description: Rabbit user
            rabbit_password:
                type: string
                required: false
                description: Rabbit password

    tosca.nodes.Site:
        derived_from: tosca.nodes.Root
        description: >
            An XOS Site. Sites are containers for Users and/or Nodes.
        capabilities:
            site:
                type: tosca.capabilities.xos.Site
        properties:
            xos_base_props
            display_name:
                type: string
                required: false
                description: Name of the site.
            site_url:
                type: string
                required: false
                description: URL of site web page.
            enabled:
                type: boolean
                default: true
            hosts_nodes:
                type: boolean
                default: true
                description: If True, then this site hosts nodes where Instances may be instantiated.
            hosts_users:
                type: boolean
                default: true
                description: If True, then this site hosts users who may use XOS.
            is_public:
                type: boolean
                default: true
            # location, longitude, latitude

    tosca.nodes.Slice:
        derived_from: tosca.nodes.Root
        description: >
            An XOS Slice. A slice is a collection of instances that share
            common attributes.
        capabilities:
            slice:
                type: tosca.capabilities.xos.Slice
        properties:
            xos_base_props
            enabled:
                type: boolean
                default: true
            description:
                type: string
                required: false
                description: Description of this slice.
            slice_url:
                type: string
                required: false
                description: URL to web page that describes slice.
            max_instances:
                type: integer
                default: 10
                description: Quota of instances that this slice may create.
            default_isolation:
                type: string
                required: false
                description: default isolation to use when bringing up instances (default to 'vm')
            default_flavor:
                # Note: we should probably formally introduce flavors to Tosca
                # at some point, and use a requirement/relationship instead of
                # a text string.
                type: string
                required: false
                description: default flavor to use for slice
            default_node:
                type: string
                required: false
                description: default node to use for this slice
            network:
                type: string
                required: false
                description: type of networking to use for this slice
            exposed_ports:
                type: string
                required: false
                description: comma-separated list of protocol _space_ port that represent ports the slice should expose

    tosca.nodes.Node:
        derived_from: tosca.nodes.Root
        description: >
            An XOS Node. Nodes are physical machines that host virtual machines
            and/or containers.
        properties:
            xos_base_props
        capabilities:
            node:
                type: tosca.capabilities.xos.Node

    tosca.nodes.DashboardView:
        derived_from: tosca.nodes.Root
        description: >
            An XOS Dashboard View
        capabilities:
            dashboardview:
                type: tosca.capabilities.xos.DashboardView
        properties:
            xos_base_props
            enabled:
                type: boolean
                default: true
            url:
                type: string
                required: false
                description: URL to the dashboard

    tosca.nodes.Compute.Container:
      derived_from: tosca.nodes.Compute
      description: >
        The TOSCA Compute node represents a container on bare metal.
      attributes:
        private_address:
          type: string
        public_address:
          type: string
      capabilities:
          host:
             type: tosca.capabilities.Container
          binding:
             type: tosca.capabilities.network.Bindable
          os:
             type: tosca.capabilities.OperatingSystem
          scalable:
             type: tosca.capabilities.Scalable
      requirements:
        - local_storage:
            capability: tosca.capabilities.Attachment
            node: tosca.nodes.BlockStorage
            relationship: tosca.relationships.AttachesTo
            occurrences: [0, UNBOUNDED]

    tosca.relationships.MemberOfSlice:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Slice ]

    tosca.relationships.MemberOfService:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Service ]

    tosca.relationships.MemberOfSite:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Site ]

    tosca.relationships.MemberOfDeployment:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Deployment ]

    tosca.relationships.TenantOfService:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Service ]

    tosca.relationships.UsedByService:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Service ]

    tosca.relationships.ControllerDeployment:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Deployment ]

    tosca.relationships SiteDeployment:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Deployment ]

    tosca.relationships.UsesController:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Controller ]

    tosca.relationships.ConnectsToNetwork:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Network ]

    tosca.relationships.UsesImage:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Image ]

    tosca.relationships.DefaultImage:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Image ]

    tosca.relationships.SupportsImage:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Image ]

    tosca.relationships.ConnectsToSlice:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Slice ]

    #    tosca.relationships.OwnsNetwork:
    #        derived_from: tosca.relationships.Root
    #        valid_target_types: [ tosca.capabilities.xos.Network ]

    tosca.relationships.UsesNetworkTemplate:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.NetworkTemplate ]

    tosca.relationships.AdminPrivilege:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Slice, tosca.capabilities.xos.Site ]

    tosca.relationships.AccessPrivilege:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Slice, tosca.capabilities.xos.Site ]

    tosca.relationships.PIPrivilege:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Site ]

    tosca.relationships.TechPrivilege:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Site ]

    tosca.relationships.SubscriberDevice:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Subscriber ]

    tosca.relationships.BelongsToSubscriber:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.Subscriber ]

    tosca.relationships.UsesDashboard:
        derived_from: tosca.relationships.Root
        valid_target_types: [ tosca.capabilities.xos.DashboardView ]

    tosca.capabilities.xos.Service:
        derived_from: tosca.capabilities.Root
        description: An XOS Service

    tosca.capabilities.xos.Deployment:
        derived_from: tosca.capabilities.Root
        description: An XOS Deployment

    tosca.capabilities.xos.Controller:
        derived_from: tosca.capabilities.Root
        description: An XOS Controller

    tosca.capabilities.xos.Site:
        derived_from: tosca.capabilities.Root
        description: An XOS Site

    tosca.capabilities.xos.Slice:
        derived_from: tosca.capabilities.Root
        description: An XOS Slice

    tosca.capabilities.xos.NetworkTemplate:
        derived_from: tosca.capabilities.Root
        description: An XOS network template

#    tosca.capabilities.xos.Network:
#        derived_from: tosca.capabilities.Root
#        description: An XOS network

    tosca.capabilities.xos.User:
        derived_from: tosca.capabilities.Root
        description: An XOS user

    tosca.capabilities.xos.Subscriber:
        derived_from: tosca.capabilities.Root
        description: An XOS Subscriber

    tosca.capabilities.xos.Device:
        derived_from: tosca.capabilities.Root
        description: A device belonging to an XOS subscriber

    tosca.capabilities.xos.Node:
        derived_from: tosca.capabilities.Root
        description: An XOS Node

    tosca.capabilities.xos.Image:
        derived_from: tosca.capabilities.Root
        description: An XOS Image

    tosca.capabilities.xos.DashboardView:
        derived_from: tosca.capabilities.Root
        description: An XOS DashboardView

    tosca.capabilities.xos.NetworkParameterType:
        derived_from: tosca.capabilities.Root
        description: An XOS NetworkParameterType
