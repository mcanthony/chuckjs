define(["chuck", "spec/helpers"], (chuckModule, helpers) ->
  describe("Arrays", ->
    {executeCode, verify} = helpers

    beforeEach(->
      helpers.beforeEach()
      spyOn(console, 'log')
    )
    afterEach(->
      helpers.afterEach()
    )

    it("can be instantiated with a size", ->
      executeCode("""int array[1];
<<<array[0]>>>;
""")

      verify(->
        expect(console.log).toHaveBeenCalledWith("0 : (int)")
      )
    )

    it("can be indexed with integer variables", ->
      executeCode("""int array[3];
1 => int i;
<<<array[i]>>>;
""")

      verify(->
        expect(console.log).toHaveBeenCalledWith("0 : (int)")
      )
    )

    describe("of UGens", ->
      it("elements can be connected to destinations", ->
        executeCode("""\
SinOsc oscs[2];
oscs[0] => dac;
oscs[1] => dac;
1::second => now;
""")

        runs(->
          # Verify the program's execution
          dac = helpers.getDac()
          expect(dac._channels[0].sources.length).toBe(2, "Sine oscillators should be connected to DAC")
          sine1 = dac._channels[0].sources[0]
          sine2 = dac._channels[0].sources[1]
          expect(dac._channels[1].sources.length).toBe(2, "Sine oscillators should be connected to DAC")
          helpers.verifySinOsc(sine1)
          helpers.verifySinOsc(sine2)
        )

        verify(->
          dac = helpers.getDac()
          for i in [0...dac._channels.length]
            channel = dac._channels[i]
            expect(channel.sources.length).toBe(0, "DAC channel #{i} sources should be empty")
          expect(helpers.fakeScriptProcessor.disconnect).toHaveBeenCalled()
        , 1)
      )
    )
  )
)