"""
pythonedarealmunveilingpartner/unveilingpartner.py

This file declares the UnveilingPartner class.

Copyright (C) 2023-today rydnr's pythoneda-realm/unveilingpartner

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
from pythoneda.value_object import attribute, sensitive, ValueObject

import abc

class UnveilingPartner(ValueObject, abc.ABC):
    """
    Represents UnveilingPartner.

    Class name: UnveilingPartner

    Responsibilities:
        - Does whatever UnveilingPartner can do in the PythonEDA ecosystem.

    Collaborators:
        - Potentially, any PythonEDA domain.
    """

    _singleton = None

    def __init__(self, masterPassword: str):
        """
        Creates a new UnveilingPartner instance.
        """
        super().__init__()
        self._master_password = masterPassword


    @property
    @attribute
    @sensitive
    def master_password(self):
        """
        Retrieves the master password.
        :return: The password.
        :rtype: str
        """
        return self._master_password

    @classmethod
    def instance(cls):
        """
        Retrieves the singleton instance.
        :return: Such instance.
        :rtype: PythonEDA
        """
        if cls._singleton is None:
            cls._singleton = cls.initialize()

        return cls._singleton

    @abc.abstractclassmethod
    @classmethod
    def initialize(cls) -> UnveilingPartner:
        """
        Initializes the singleton instance.
        :return: The singleton instance.
        :rtype: UnveilingPartner
        """
