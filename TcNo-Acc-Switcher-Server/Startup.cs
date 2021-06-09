// TcNo Account Switcher - A Super fast account switcher
// Copyright (C) 2019-2021 TechNobo (Wesley Pyburn)
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

using System;
using System.Globalization;
using System.Linq;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Localization;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;
using TcNo_Acc_Switcher_Globals;
using TcNo_Acc_Switcher_Server.Data;

namespace TcNo_Acc_Switcher_Server
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
            // Crash handler
            AppDomain.CurrentDomain.UnhandledException += Globals.CurrentDomain_UnhandledException;
            services.AddControllers();
            services.AddLocalization(x => { x.ResourcesPath = "Resources"; });
            services.AddRazorPages();
            services.AddServerSideBlazor().AddCircuitOptions(x => { x.DetailedErrors = true; });
            // Persistent settings:
            services.AddSingleton<AppSettings>(); // App Settings
            services.AddSingleton<AppData>(); // App Data
            services.AddSingleton<Data.Settings.BattleNet>(); // BattleNet
            services.AddSingleton<Data.Settings.Epic>(); // Epic
            services.AddSingleton<Data.Settings.Origin>(); // Origin
            services.AddSingleton<Data.Settings.Riot>(); // Riot Games
            services.AddSingleton<Data.Settings.Steam>(); // Steam
            services.AddSingleton<Data.Settings.Ubisoft>(); // Ubisoft


            var options = Options.Create(new LocalizationOptions { ResourcesPath = "Resources" });
            var factory = new Net5ResourceManagerStringLocalizerFactory(options, NullLoggerFactory.Instance);// Use the implementation from aspnet/Extensions master

            CultureInfo.CurrentUICulture = new CultureInfo("en");
            var valuesLoc = factory.Create(typeof(Program));
            Console.WriteLine(valuesLoc["update"]); // Expected: "EnglishValue"

            CultureInfo.CurrentUICulture = new CultureInfo("fr");
            Console.WriteLine(valuesLoc["update"]); // Expected: "FrenchValue"

        }

        private RequestLocalizationOptions GetLocalisationOptions()
        {
            var cultures = Configuration.GetSection("Cultures")
                .GetChildren().ToDictionary(x => x.Key, x => x.Value);

            var supportedCultures = cultures.Keys.ToArray();

            var localisationOptions = new RequestLocalizationOptions()
                .AddSupportedCultures(supportedCultures)
                .AddSupportedUICultures(supportedCultures);

            return localisationOptions;
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Error");
            }

            app.UseStaticFiles();

            app.UseRequestLocalization(GetLocalisationOptions());

            app.UseRouting();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
                endpoints.MapDefaultControllerRoute();

                endpoints.MapBlazorHub();
                endpoints.MapFallbackToPage("/_Host");
            });
        }
    }
}
