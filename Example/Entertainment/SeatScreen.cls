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
    File        : SeatScreen
    Purpose     : A general screen
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk. Ltd.
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.Lang.* from propath.
using Example.Entertainment.* from propath.

class Example.Entertainment.SeatScreen inherits SeatDecorator
    implements ISeatScreen:

    define public property Height as integer no-undo
    get.
    private set.

    define public property Width as integer no-undo
    get.
    private set.

    define public property Resolution  as ResolutionEnum no-undo
    get.
    private set.

    define public property SupportsPictureInPicture as logical no-undo
    get.
    private set.

    define public property SupportsTouch as logical no-undo
    get.
    private set.

    constructor public SeatScreen(piHeight as integer,
                                  piWidth as integer,
                                  poResolution as ResolutionEnum,
                                  plPip as logical,
                                  plTouch as logical,
                                  poDecoratedSeat as ISeat):
        super(poDecoratedSeat).

        this-object:Height = piHeight.
        this-object:Width  = piWidth.
        this-object:Resolution = poResolution.
        this-object:SupportsPictureInPicture = plPip.
        this-object:SupportsTouch = plTouch.

    end constructor.

    method public void PlayPipChannel(poChannel as ChannelTypeEnum, pcId as character):
        if not this-object:SupportsPictureInPicture then
            message this-object:GetClass():TypeName + ':PlayPipChannel PiP not supported for this screen'.
        else if poChannel <> ChannelTypeEnum:Map and poChannel <> ChannelTypeEnum:Tv then
            message this-object:GetClass():TypeName + ':PlayPipChannel PiP not supported for this channel ' + string(poChannel).
        else
            message this-object:GetClass():TypeName + ':PlayPipChannel ' string(poChannel) pcId.
    end method.

end class.

