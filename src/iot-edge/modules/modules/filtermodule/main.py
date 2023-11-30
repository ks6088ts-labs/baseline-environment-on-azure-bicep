# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for
# full license information.

import asyncio
import sys
import signal
import threading
import json
from azure.iot.device.aio import IoTHubModuleClient

# global counters
TEMPERATURE_THRESHOLD = 25
TWIN_CALLBACKS = 0
RECEIVED_MESSAGES = 0

# Event indicating client stop
stop_event = threading.Event()


def create_client():
    client = IoTHubModuleClient.create_from_edge_environment()

    # Define function for handling received messages
    async def receive_message_handler(message):
        global RECEIVED_MESSAGES
        print("Message received")
        size = len(message.data)
        message_text = message.data.decode('utf-8')
        print("    Data: <<<{data}>>> & Size={size}".format(data=message.data, size=size))
        print("    Properties: {}".format(message.custom_properties))
        RECEIVED_MESSAGES += 1
        print("Total messages received: {}".format(RECEIVED_MESSAGES))

        if message.input_name == "input1":
            message_json = json.loads(message_text)
            if "machine" in message_json and "temperature" in message_json["machine"] and message_json["machine"]["temperature"] > TEMPERATURE_THRESHOLD:
                message.custom_properties["MessageType"] = "Alert"
                print("ALERT: Machine temperature {temp} exceeds threshold {threshold}".format(
                    temp=message_json["machine"]["temperature"], threshold=TEMPERATURE_THRESHOLD
                ))
                await client.send_message_to_output(message, "output1")

    # Define function for handling received twin patches
    async def receive_twin_patch_handler(twin_patch):
        global TEMPERATURE_THRESHOLD
        global TWIN_CALLBACKS
        print("Twin Patch received")
        print("     {}".format(twin_patch))
        if "TemperatureThreshold" in twin_patch:
            TEMPERATURE_THRESHOLD = twin_patch["TemperatureThreshold"]
        TWIN_CALLBACKS += 1
        print("Total calls confirmed: {}".format(TWIN_CALLBACKS))

    try:
        # Set handler on the client
        client.on_message_received = receive_message_handler
        client.on_twin_desired_properties_patch_received = receive_twin_patch_handler
    except:
        # Cleanup if failure occurs
        client.shutdown()
        raise

    return client


async def run_sample(client):
    # Customize this coroutine to do whatever tasks the module initiates
    # e.g. sending messages
    while True:
        await asyncio.sleep(1000)


def main():
    if not sys.version >= "3.5.3":
        raise Exception( "The sample requires python 3.5.3+. Current version of Python: %s" % sys.version )
    print ( "IoT Hub Client for Python" )

    # NOTE: Client is implicitly connected due to the handler being set on it
    client = create_client()

    # Define a handler to cleanup when module is is terminated by Edge
    def module_termination_handler(signal, frame):
        print ("IoTHubClient sample stopped by Edge")
        stop_event.set()

    # Set the Edge termination handler
    signal.signal(signal.SIGTERM, module_termination_handler)

    # Run the sample
    loop = asyncio.get_event_loop()
    try:
        loop.run_until_complete(run_sample(client))
    except Exception as e:
        print("Unexpected error %s " % e)
        raise
    finally:
        print("Shutting down IoT Hub Client...")
        loop.run_until_complete(client.shutdown())
        loop.close()


if __name__ == "__main__":
    main()
