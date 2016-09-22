using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(AEILWebForms.Startup))]
namespace AEILWebForms
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
