using System.Collections.Generic;
using System.Data.SqlClient;
using binary.Core.DAL;
using binary.Models;

namespace binary.Core.BLL
{
    public class CategoryBLL
    {
        private readonly CategoryDAL _dal = new CategoryDAL();

        public List<Category> GetAllCategories()
        {
            return _dal.SelectAll();
        }

        public Category GetCategoryById(int categoryId)
        {
            if (categoryId <= 0)
                throw new ValidationException("Invalid category ID.");

            Category c = _dal.SelectById(categoryId);
            if (c == null)
                throw new ValidationException("Category not found.");

            return c;
        }

        public int AddCategory(Category c)
        {
            Validate(c);
            return _dal.Insert(c);
        }

        public void UpdateCategory(Category c)
        {
            Validate(c);
            if (c.CategoryID <= 0)
                throw new ValidationException("Invalid category ID.");

            _dal.Update(c);
        }

        public void DeleteCategory(int categoryId)
        {
            if (categoryId <= 0)
                throw new ValidationException("Invalid category ID.");

            try
            {
                _dal.Delete(categoryId);
            }
            catch (SqlException sqlEx) when (sqlEx.Number == 547)
            {
                // 547 = foreign key constraint violation
                throw new ValidationException("Cannot delete a category that still has courses.");
            }
        }

        private void Validate(Category c)
        {
            if (c == null)
                throw new ValidationException("No category data supplied.");
            if (string.IsNullOrWhiteSpace(c.Name))
                throw new ValidationException("Category name is required.");
            if (c.Name.Trim().Length > 100)
                throw new ValidationException("Category name must be 100 characters or fewer.");
        }
    }
}
