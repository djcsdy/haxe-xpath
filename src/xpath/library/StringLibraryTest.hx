/* Haxe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS 
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */


package xpath.library;
import haxe.unit.TestCase;
import xpath.context.FakeContext;
import xpath.value.XPathValue;
import xpath.value.XPathBoolean;
import xpath.value.XPathNumber;
import xpath.value.XPathString;
import xpath.xml.XPathXml;
import xpath.xml.XPathHxXml;
import xpath.EvaluationException;


class StringLibraryTest extends TestCase {
	
	function testConcat () {
		var context = new FakeContext();
		var result = StringLibrary.concat(context, [
			cast(new XPathString("foo"), XPathValue),
			new XPathString("bar")
		]);
		assertTrue(Std.is(result, XPathString));
		assertEquals("foobar", result.getString());
		
		result = StringLibrary.concat(context, [
			cast(new XPathString("foo"), XPathValue),
			new XPathString("bar"),
			new XPathString("bat")
		]);
		
		var caught = false;
		try {
			StringLibrary.concat(context, []);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			StringLibrary.concat(context, [
				cast(new XPathString("foo"), XPathValue)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testStartsWith () {
		var context = new FakeContext();
		var result = StringLibrary.startsWith(context, [
			cast(new XPathString("foobar"), XPathValue),
			new XPathString("foo")
		]);
		assertTrue(Std.is(result, XPathBoolean));
		assertTrue(result.getBool());
		
		result = StringLibrary.startsWith(context, [
			cast(new XPathString("foobar"), XPathValue),
			new XPathString("")
		]);
		assertTrue(Std.is(result, XPathBoolean));
		assertTrue(result.getBool());
		
		result = StringLibrary.startsWith(context, [
			cast(new XPathString("foobar"), XPathValue),
			new XPathString("fob")
		]);
		assertTrue(Std.is(result, XPathBoolean));
		assertFalse(result.getBool());
		
		result = StringLibrary.startsWith(context, [
			cast(new XPathString("foo"), XPathValue),
			new XPathString("foobar")
		]);
		assertTrue(Std.is(result, XPathBoolean));
		assertFalse(result.getBool());
		
		var caught = false;
		try {
			StringLibrary.startsWith(context, []);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			StringLibrary.startsWith(context, [
				cast(new XPathString("foo"), XPathValue)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			StringLibrary.startsWith(context, [
				cast(new XPathString("foo"), XPathValue),
				new XPathString("bar"),
				new XPathString("bat")
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testContains () {
		var context = new FakeContext();
		var result = StringLibrary.contains(context, [
			cast(new XPathString("foo"), XPathValue),
			new XPathString("bar")
		]);
		assertTrue(Std.is(result, XPathBoolean));
		assertFalse(result.getBool());
		
		result = StringLibrary.contains(context, [
			cast(new XPathString("strawberries"), XPathValue),
			new XPathString("straw")
		]);
		assertTrue(Std.is(result, XPathBoolean));
		assertTrue(result.getBool());
		
		result = StringLibrary.contains(context, [
			cast(new XPathString("strawberries"), XPathValue),
			new XPathString("raw")
		]);
		assertTrue(Std.is(result, XPathBoolean));
		assertTrue(result.getBool());
		
		result = StringLibrary.contains(context, [
			cast(new XPathString("strawberries"), XPathValue),
			new XPathString("berries")
		]);
		assertTrue(Std.is(result, XPathBoolean));
		assertTrue(result.getBool());
		
		result = StringLibrary.contains(context, [
			cast(new XPathString("strawberries"), XPathValue),
			new XPathString("")
		]);
		assertTrue(Std.is(result, XPathBoolean));
		assertTrue(result.getBool());
		
		var caught = false;
		try {
			StringLibrary.contains(context, []);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			StringLibrary.contains(context, [
				cast(new XPathString("foo"), XPathValue)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			StringLibrary.contains(context, [
				cast(new XPathString("foo"), XPathValue),
				new XPathString("bar"),
				new XPathString("bat")
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testSubstringBefore () {
		var context = new FakeContext();
		var result = StringLibrary.substringBefore(context, [
			cast(new XPathString("2007-12-12"), XPathValue),
			new XPathString("-")
		]);
		assertTrue(Std.is(result, XPathString));
		assertEquals("2007", result.getString());
		
		result = StringLibrary.substringBefore(context, [
			cast(new XPathString("2007-12-12"), XPathValue),
			new XPathString("ekki-ekki-ekki-ekki-PTANG zoom-boing z'nourrwringmm")
		]);
		assertTrue(Std.is(result, XPathString));
		assertEquals("", result.getString());
		
		var caught = false;
		try {
			StringLibrary.substringBefore(context, []);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			StringLibrary.substringBefore(context, [
				cast(new XPathString("2007-12-12"), XPathValue)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			StringLibrary.substringBefore(context, [
				cast(new XPathString("2007-12-12"), XPathValue),
				new XPathString("ekki-ekki-ekki-ekki-PTANG zoom-boing z'nourrwringmm"),
				new XPathString("flumble")
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testSubstringAfter () {
		var context = new FakeContext();
		var result = StringLibrary.substringAfter(context, [
			cast(new XPathString("2007-12-12"), XPathValue),
			new XPathString("-")
		]);
		assertTrue(Std.is(result, XPathString));
		assertEquals("12-12", result.getString());
		
		result = StringLibrary.substringAfter(context, [
			cast(new XPathString("2007-12-12"), XPathValue),
			new XPathString("ekki-ekki-ekki-ekki-PTANG zoom-boing z'nourrwringmm")
		]);
		assertTrue(Std.is(result, XPathString));
		assertEquals("", result.getString());
		
		var caught = false;
		try {
			StringLibrary.substringAfter(context, []);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			StringLibrary.substringAfter(context, [
				cast(new XPathString("2007-12-12"), XPathValue)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			StringLibrary.substringAfter(context, [
				cast(new XPathString("2007-12-12"), XPathValue),
				new XPathString("ekki-ekki-ekki-ekki-PTANG zoom-boing z'nourrwringmm"),
				new XPathString("flumble")
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testSubstring () {
		var context = new FakeContext();
		var result = StringLibrary.substring(context, [
			cast(new XPathString("2007-12-12"), XPathValue),
			new XPathNumber(6)
		]);
		assertTrue(Std.is(result, XPathString));
		assertEquals("12-12", result.getString());
		
		result = StringLibrary.substring(context, [
			cast(new XPathString("2007-12-12"), XPathValue),
			new XPathNumber(6), new XPathNumber(2)
		]);
		assertTrue(Std.is(result, XPathString));
		assertEquals("12", result.getString());
		
		result = StringLibrary.substring(context, [
			cast(new XPathString("2007-12-12"), XPathValue),
			new XPathNumber(6), new XPathNumber(42)
		]);
		assertTrue(Std.is(result, XPathString));
		assertEquals("12-12", result.getString());
		
		result = StringLibrary.substring(context, [
			cast(new XPathString("2007-12-12"), XPathValue),
			new XPathNumber(42), new XPathNumber(314159)
		]);
		assertTrue(Std.is(result, XPathString));
		assertEquals("", result.getString());
		
		result = StringLibrary.substring(context, [
			cast(new XPathString("2007-12-12"), XPathValue),
			new XPathNumber(-1/0)
		]);
		assertEquals("2007-12-12", result.getString());
		
		result = StringLibrary.substring(context, [
			cast(new XPathString("12345"), XPathValue),
			new XPathNumber(1.5), new XPathNumber(2.6)
		]);
		assertEquals("234", result.getString());
		
		result = StringLibrary.substring(context, [
			cast(new XPathString("12345"), XPathValue),
			new XPathNumber(0), new XPathNumber(3)
		]);
		assertEquals("12", result.getString());
		
		result = StringLibrary.substring(context, [
			cast(new XPathString("12345"), XPathValue),
			new XPathNumber(Math.NaN), new XPathNumber(3)
		]);
		assertEquals("", result.getString());
		
		result = StringLibrary.substring(context, [
			cast(new XPathString("12345"), XPathValue),
			new XPathNumber(1), new XPathNumber(0/0)
		]);
		assertEquals("", result.getString());
		
		result = StringLibrary.substring(context, [
			cast(new XPathString("12345"), XPathValue),
			new XPathNumber(-42), new XPathNumber(1/0)
		]);
		assertEquals("12345", result.getString());
		
		result = StringLibrary.substring(context, [
			cast(new XPathString("12345"), XPathValue),
			new XPathNumber(-1/0), new XPathNumber(1/0)
		]);
		assertEquals("", result.getString());
		
		result = StringLibrary.substring(context, [
			cast(new XPathString("12345"), XPathValue),
			new XPathNumber(-42), new XPathNumber(-1/0)
		]);
		assertEquals("", result.getString());
		
		var caught = false;
		try {
			StringLibrary.substring(context, [
				cast(new XPathString("bananas"), XPathValue)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			StringLibrary.substring(context, [
				cast(new XPathString("bananas"), XPathValue),
				new XPathNumber(42), new XPathNumber(3.14159),
				new XPathNumber(227)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testStringLength () {
		var contextNode:XPathXml = XPathHxXml.wrapNode(
			Xml.createCData("bananas")
		);
		var context = new FakeContext(contextNode);
		var result = StringLibrary.stringLength(context, []);
		assertTrue(Std.is(result, XPathNumber));
		assertEquals(7., result.getFloat());
		
		var context = new FakeContext();
		var result = StringLibrary.stringLength(context, [
			cast(new XPathString("apples"), XPathValue)
		]);
		assertTrue(Std.is(result, XPathNumber));
		assertEquals(6., result.getFloat());
		
		var caught = false;
		try {
			StringLibrary.stringLength(context, [
				cast(new XPathString("pears"), XPathValue),
				cast(new XPathString("grapes"), XPathValue)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testNormalizeSpace () {
		var contextNode:XPathXml = XPathHxXml.wrapNode(
			Xml.createCData("bananas")
		);
		var context = new FakeContext(contextNode);
		var result = StringLibrary.normalizeSpace(context, []);
		assertTrue(Std.is(result, XPathString));
		assertEquals("bananas", result.getString());
		
		context = new FakeContext();
		result = StringLibrary.normalizeSpace(context, [
			cast(new XPathString("bananas"), XPathValue)
		]);
		assertTrue(Std.is(result, XPathString));
		assertEquals("bananas", result.getString());
		
		result = StringLibrary.normalizeSpace(context, [
			cast(new XPathString("   apples"), XPathValue)
		]);
		assertEquals("apples", result.getString());
		
		result = StringLibrary.normalizeSpace(context, [
			cast(new XPathString("pears    "), XPathValue)
		]);
		assertEquals("pears", result.getString());
		
		result = StringLibrary.normalizeSpace(context, [
			cast(new XPathString(
				"   apples   pears   \r  and\nbananas\t\t  "
			), XPathValue)
		]);
		assertEquals("apples pears and bananas", result.getString());
		
		var caught = false;
		try {
			StringLibrary.normalizeSpace(context, [
				cast(new XPathString("cherries"), XPathValue),
				new XPathString("pineapples")
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testTranslate () {
		var context = new FakeContext();
		var result = StringLibrary.translate(context, [
			cast(new XPathString("bananas"), XPathValue),
			new XPathString("abcn"), new XPathString("bcd")
		]);
		assertTrue(Std.is(result, XPathString));
		assertEquals("cbbbs", result.getString());
		
		var caught = false;
		try {
			StringLibrary.translate(context, []);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			StringLibrary.translate(context, [
				cast(new XPathString("bananas"), XPathValue)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			StringLibrary.translate(context, [
				cast(new XPathString("bananas"), XPathValue),
				new XPathString("abcn")
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			StringLibrary.translate(context, [
				cast(new XPathString("bananas"), XPathValue),
				new XPathString("abcn"), new XPathString("bcd"),
				new XPathString("hatstand")
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
}
