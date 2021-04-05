import asyncio

from proto import registry_msg_pb2 as msg_pb2

from .comm import _recv_msg, _send_msg
from .constants import UNIX_SOCKET_PATH


class LocalRegistryClient(object):
    def __init__(self):
        self.reader = None
        self.writer = None
        self.req_seq = 0

    def _parse_response(self, any):
        if not any.Is(msg_pb2.Response.DESCRIPTOR):
            return None

        resp = msg_pb2.Response()
        any.Unpack(resp)

        if resp.status == msg_pb2.Response.OK and resp.req_seq == self.req_seq:
            return resp
        else:
            print('unknown message')
            return None

    async def register(self, job, channel, role, uid, endpoint):
        self.req_seq += 1
        msg = msg_pb2.Set()
        msg.req_seq = self.req_seq
        msg.uid = uid
        msg.endpoint = endpoint

        rec = msg_pb2.Record()
        rec.job = job
        rec.channel = channel
        rec.role = role

        msg.record.append(rec)

        # send message
        await _send_msg(self.writer, msg)

        # wait for response
        any_msg = await _recv_msg(self.reader)

        resp = self._parse_response(any_msg)

        return True if resp else False

    async def get(self, job, channel):
        self.req_seq += 1
        msg = msg_pb2.Get()
        msg.req_seq = self.req_seq

        rec = msg_pb2.Record()
        rec.job = job
        rec.channel = channel

        msg.record.append(rec)

        # send message
        await _send_msg(self.writer, msg)

        # wait for response
        any_msg = await _recv_msg(self.reader)

        resp = self._parse_response(any_msg)

        if not resp:
            return None

        result = []
        for role, uidep in resp.role_to_uidep.items():
            for idx in range(len(uidep.uid)):
                result.append((role, uidep.uid[idx], uidep.endpoint[idx]))

        return result

    async def connect(self):
        reader, writer = await asyncio.open_unix_connection(
            f'{UNIX_SOCKET_PATH}'
        )

        self.reader = reader
        self.writer = writer


async def main():
    client = LocalRegistryClient()
    await client.connect()
    await client.register('job1', 'ch1', 'role1', 'uid1', 'endpoint1')
    await client.register('job1', 'ch3', 'role1', 'uid1', 'endpoint1')
    await client.register('job1', 'ch3', 'role1', 'uid2', 'endpoint2')
    result = await client.get('job1', 'ch3')
    print(result)


if __name__ == "__main__":
    asyncio.run(main())