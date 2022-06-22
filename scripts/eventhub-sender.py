import asyncio
from azure.eventhub.aio import EventHubProducerClient
from azure.eventhub import EventData


async def run():
    # Create a producer client to send messages to the event hub.
    # Specify a connection string to your event hubs namespace and
    # the event hub name.
    producer = EventHubProducerClient.from_connection_string(conn_str="Endpoint=sb://testbos1.servicebus.windows.net/;SharedAccessKeyName=send-listen-hub;SharedAccessKey=zLmXBQrZgvze8MDVh7fPMEXYvuaZ3ifh0hMf7M0/Ja4=;EntityPath=testhub1", eventhub_name="testhub1")
    async with producer:
        # Create a batch.
        event_data_batch = await producer.create_batch()

        # Add events to the batch.
        event_data_batch.add(EventData('First event '))
        event_data_batch.add(EventData('Second event'))
        event_data_batch.add(EventData('Third event'))

        # Send the batch of events to the event hub.
        await producer.send_batch(event_data_batch)

loop = asyncio.get_event_loop()
loop.run_until_complete(run())