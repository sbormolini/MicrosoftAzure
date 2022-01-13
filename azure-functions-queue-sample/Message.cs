using Newtonsoft.Json;
using System;

namespace StorageQueueDemo;

public record Message
{
    [JsonProperty("sp1TicketID")]
    public string ServiceProvider1TicketId { get; set; }

    [JsonProperty("sp2TicketID")]
    public string ServiceProvider2TicketId { get; set; }

    [JsonProperty("created")]
    public DateTime CreationDate { get; set; }
}
