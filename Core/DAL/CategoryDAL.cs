using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using binary.Core.Helpers;
using binary.Models;

namespace binary.Core.DAL
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

        public int Insert(Category c)
        {
            const string sql = @"
                INSERT INTO Categories (Name) VALUES (@Name);
                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Name", c.Name);
                return (int)cmd.ExecuteScalar();
            }
        }

        public void Update(Category c)
        {
            const string sql = "UPDATE Categories SET Name = @Name WHERE CategoryID = @CategoryID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@Name", c.Name);
                DbHelper.AddParam(cmd, "@CategoryID", c.CategoryID);
                cmd.ExecuteNonQuery();
            }
        }

        public void Delete(int categoryId)
        {
            const string sql = "DELETE FROM Categories WHERE CategoryID = @CategoryID;";

            using (SqlConnection con = DbHelper.CreateConnection())
            using (SqlCommand cmd = DbHelper.CreateCommand(con, sql))
            {
                DbHelper.AddParam(cmd, "@CategoryID", categoryId);
                cmd.ExecuteNonQuery();
            }
        }
    }
}
