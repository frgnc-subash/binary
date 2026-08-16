using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace binary.Helpers
{
    // shared database connection and command helpers
    public static class DbHelper
    {
        private static readonly string _connectionString =
            ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;

        // creates and opens sql connection
        public static SqlConnection CreateConnection()
        {
            SqlConnection con = new SqlConnection(_connectionString);
            con.Open();
            return con;
        }

        // creates sql command
        public static SqlCommand CreateCommand(SqlConnection con, string sql)
        {
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.CommandType = CommandType.Text;
            return cmd;
        }

        // attaches parameter with dbnull fallback
        public static void AddParam(SqlCommand cmd, string name, object value)
        {
            cmd.Parameters.AddWithValue(name, value ?? DBNull.Value);
        }
    }
}
