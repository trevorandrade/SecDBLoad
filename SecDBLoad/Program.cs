using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Threading.Tasks;
using System.IO.Compression;
using System.Security.AccessControl;
using System.Security.Principal;
using Npgsql;

namespace SecDBLoad
{
    class Program
    {
        private static string[] filetypes = new string[] { "num", "sub", "pre", "tag" };
        static void Main(string[] args)
        {
            //string[] yearAndQuarters = { "2017q1", "2017q2" };
            string[] yearAndQuarters = { "2017q2", "2017q1", "2016q4", "2016q3", "2016q2", "2016q1", "2015q4", "2015q3", "2015q2", "2015q1", "2014q4", "2014q3", "2014q2", "2014q1", "2013q4", "2013q3", "2013q2", "2013q1", "2012q4", "2012q3", "2012q2", "2012q1", "2011q4", "2011q3", "2011q2", "2011q1", "2010q4", "2010q3", "2010q2", "2010q1", "2009q4", "2009q3", "2009q2", "2009q1", };
            foreach (string yearAndQuarter in yearAndQuarters)
            {
                GrabProcessAndStore(yearAndQuarter);
            }
        }

        private static void GrabProcessAndStore(string yearAndQuarter)
        {
            string fileName = yearAndQuarter + ".zip";
            string folder = @"C:\Users\Trevor\Desktop\secdb";
            string zipFilePath = Path.Combine(folder, fileName);
            DownloadFileFromSEC(fileName, zipFilePath);
            ZipFile.ExtractToDirectory(zipFilePath, Path.Combine(folder, yearAndQuarter));
            filetypes.ToList<string>().ForEach(filetype =>
            {
                string fullpath = $@"C:\Users\Trevor\Desktop\secdb\{yearAndQuarter}\{filetype}fixed.txt";
                ConvertFile($@"C:\Users\Trevor\Desktop\secdb\{yearAndQuarter}\{filetype}.txt", fullpath);
                GrantAccess(fullpath);
                CopyToPostgres(filetype, fullpath);
            });
        }

        private static void GrantAccess(string fullPath)
        {
            DirectoryInfo dInfo = new DirectoryInfo(fullPath);
            DirectorySecurity dSecurity = dInfo.GetAccessControl();
            dSecurity.AddAccessRule(new FileSystemAccessRule(new SecurityIdentifier(WellKnownSidType.WorldSid, null), FileSystemRights.FullControl, InheritanceFlags.ObjectInherit | InheritanceFlags.ContainerInherit, PropagationFlags.NoPropagateInherit, AccessControlType.Allow));
            dInfo.SetAccessControl(dSecurity);
        }
        static void CopyToPostgres(string filetype, string fullpath)
        {
            try
            {
                using (NpgsqlConnection conn = new NpgsqlConnection("Server=localhost;User Id=postgres;Database=SECdb;Password=p;CommandTimeout=0;"))
                {
                    conn.Open();
                    NpgsqlCommand command = new NpgsqlCommand($@"COPY {filetype} FROM '{fullpath}' with null as ''", conn);
                    command.ExecuteNonQuery();
                }
            }
            catch(Exception ex)
            {
                Console.WriteLine(ex.Message);
                Console.ReadKey();
            }
        }
        static void ConvertFile(string inputfile, string outputfile)
        {
            Encoding encoding = new UTF8Encoding(false);
            // Create an instance of StreamReader to read from a file.
            // The using statement also closes the StreamReader.
            using (StreamReader sr = new StreamReader(inputfile))
            using (StreamWriter sw = new StreamWriter(outputfile, false, encoding))
            {
                string line = sr.ReadLine();
                // Read and display lines from the file until the end of 
                // the file is reached.
                while ((line = sr.ReadLine()) != null)
                {
                    sw.WriteLine(line.Replace("\\", ""));
                }
            }
        }
        static void DownloadFileFromSEC(string filename, string destination)
        {
            WebClient Client = new WebClient();
            Client.DownloadFile(@"https://www.sec.gov/files/dera/data/financial-statement-data-sets/" + filename, destination);
        }
    }
}