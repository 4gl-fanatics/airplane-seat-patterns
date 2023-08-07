/*
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>
*/
/*------------------------------------------------------------------------
    File        : SeatDecorator
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk. Ltd.
    Created     :
    Notes       : * There's a decent description of Decorator pattern in Wikipedia
                    at http://en.wikipedia.org/wiki/Decorator_pattern
                  * This class should be extended to provide specific functionality.
                    For instance, adding support for screens
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Example.Entertainment.* from propath.

class Example.Entertainment.SeatDecorator
    implements ISeat, OpenEdge.Core.IAdaptable
    abstract:

    define variable oDecoratedSeat as ISeat no-undo.

    define public property BluetoothEnabled as logical no-undo
    get():
        return oDecoratedSeat:BluetoothEnabled.
    end get.
    private set.

    constructor public SeatDecorator(poSeat as ISeat):
        oDecoratedSeat = poSeat.
    end constructor.

    method public void SelectOutputDevice(poDeviceType as AudioDeviceTypeEnum, poParameters as Progress.Lang.Object):
        message this-object:GetClass():TypeName + ':SelectOutputDevice ' string(poDeviceType) .

        oDecoratedSeat:SelectOutputDevice(poDeviceType, poParameters).
    end method.

    method public void PlayChannel(poChannel as ChannelTypeEnum, pcId as character):
        message this-object:GetClass():TypeName + ':PlayChannel ' string(poChannel) pcId.

        oDecoratedSeat:PlayChannel(poChannel, pcId).
    end method.

    method public Progress.Lang.Object GetAdapter(pAdaptTo as Progress.Lang.Class):
        if this-object:GetClass():IsA(pAdaptTo) then
            return this-object.

        if valid-object(oDecoratedSeat)
        and type-of(oDecoratedSeat, OpenEdge.Core.IAdaptable)
        then
            return cast(oDecoratedSeat, OpenEdge.Core.IAdaptable):GetAdapter(pAdaptTo).

        return ?.
    end method.

end class.