using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using binary.Helpers;
using binary.Models;

namespace binary.DAL
{
    public class CategoryDAL
    {
        public List<Category> SelectAll()
        {
            const string sql = "SELECT CategoryID, Name FROM Categories ORDER BY Name ASC;";
            var list = new List<Category>();

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    list.Add(new Category
                    {
                        CategoryID = Convert.ToInt32(reader["CategoryID"]),
                        Name = reader["Name"].ToString()
                    });
                }
            }
            return list;
        }

        public Category SelectById(int categoryId)
        {
            const string sql = "SELECT CategoryID, Name FROM Categories WHERE CategoryID = @CategoryID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@CategoryID", categoryId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new Category
                        {
                            CategoryID = Convert.ToInt32(reader["CategoryID"]),
                            Name = reader["Name"].ToString()
                        };
                    }
                }
            }
            return null;
        }
    }
}
