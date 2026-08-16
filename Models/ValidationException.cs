using System;

namespace binary.Models
{
    // custom exception for validation errors
    public class ValidationException : Exception
    {
        public ValidationException(string message) : base(message) { }
    }
}
