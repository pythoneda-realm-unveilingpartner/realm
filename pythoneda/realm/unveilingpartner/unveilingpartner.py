# vim: set fileencoding=utf-8
"""
pythoneda/realm/unveilingpartner/unveilingpartner.py

This file declares the Unveilingpartner class.

Copyright (C) 2023-today rydnr's pythoneda-realm-unveilingpartner/realm

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""
from pythoneda import (
    attribute,
    listen,
    sensitive,
    Event,
    EventEmitter,
    EventListener,
    Ports,
)
from pythoneda.shared.artifact.events.code import ChangeStagingCodeExecutionPackaged


class Unveilingpartner(EventListener):
    """
    Represents Unveilingpartner, Rydnr's partner to perform automated tasks on his behalf.

    Class name: Unveilingpartner

    Responsibilities:
        - Performs Automated tasks on behalf of Rydnr.

    Collaborators:
        - None
    """

    _singleton = None

    def __init__(self):
        """
        Creates a new Unveilingpartner instance.
        """
        super().__init__()

    @classmethod
    def instance(cls):
        """
        Retrieves the singleton instance.
        :return: Such instance.
        :rtype: pythoneda.realm.unveilingpartner.Unveilingpartner
        """
        if cls._singleton is None:
            cls._singleton = cls.initialize()

        return cls._singleton

    @classmethod
    @listen(ChangeStagingCodeExecutionPackaged)
    async def listen_ChangeStagingCodeExecutionPackaged(
        cls, event: ChangeStagingCodeExecutionPackaged
    ):
        """
        Gets notified of a ChangeStagingCodeExecutionPackaged event.
        :param event: The event.
        :type event: pythoneda.shared.artifact.events.code.ChangeStagingCodeExecutionPackaged
        """
        Unveilingpartner.logger().info(f"Running {type(event)}")
        await event.nix_flake.run()
# vim: syntax=python ts=4 sw=4 sts=4 tw=79 sr et
# Local Variables:
# mode: python
# python-indent-offset: 4
# tab-width: 4
# indent-tabs-mode: nil
# fill-column: 79
# End:
