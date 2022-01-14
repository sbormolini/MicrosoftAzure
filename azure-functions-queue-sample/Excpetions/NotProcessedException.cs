using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StorageQueueDemo.Excpetions;

public class NotProcessedException : Exception
{
    public NotProcessedException() : base() { }
    public NotProcessedException(string message) : base(message) { }
    public NotProcessedException(string message, Exception inner) : base(message, inner) { }

    // A constructor is needed for serialization when an
    // exception propagates from a remoting server to the client.
    protected NotProcessedException(System.Runtime.Serialization.SerializationInfo info,
        System.Runtime.Serialization.StreamingContext context) : base(info, context) { }
}
