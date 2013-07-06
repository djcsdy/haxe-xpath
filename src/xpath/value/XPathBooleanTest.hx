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


package xpath.value;
import Haxe.unit.TestCase;
import xpath.value.XPathBoolean;
import xpath.value.XPathNodeSet;
import xpath.EvaluationException;


class XPathBooleanTest extends TestCase {
	
	function testGetBool () {
		for (bool in [ true, false ]) {
			var xPathBoolean = new XPathBoolean(bool);
			assertEquals(bool, xPathBoolean.getBool());
		}
	}
	
	function testGetFloat () {
		var xPathBoolean = new XPathBoolean(true);
		assertEquals(1.0, xPathBoolean.getFloat());
		
		var xPathBoolean = new XPathBoolean(false);
		assertEquals(0.0, xPathBoolean.getFloat());
	}
	
	function testGetString () {
		var xPathBoolean = new XPathBoolean(true);
		assertEquals("true", xPathBoolean.getString());
		
		var xPathBoolean = new XPathBoolean(false);
		assertEquals("false", xPathBoolean.getString());
	}
	
	function testEquals () {
		var xPathTrue1 = new XPathBoolean(true);
		var xPathTrue2 = new XPathBoolean(true);
		var xPathFalse1 = new XPathBoolean(false);
		var xPathFalse2 = new XPathBoolean(false);
		
		assertTrue(xPathTrue1.equals(xPathTrue1).getBool());
		assertTrue(xPathTrue1.equals(xPathTrue2).getBool());
		assertFalse(xPathTrue1.equals(xPathFalse1).getBool());
		assertFalse(xPathTrue1.equals(xPathFalse2).getBool());
		assertTrue(xPathTrue2.equals(xPathTrue1).getBool());
		assertFalse(xPathFalse1.equals(xPathTrue1).getBool());
		assertTrue(xPathFalse1.equals(xPathFalse1).getBool());
		assertTrue(xPathFalse1.equals(xPathFalse2).getBool());
	}
	
	function testNotEqual () {
		var xPathTrue1 = new XPathBoolean(true);
		var xPathTrue2 = new XPathBoolean(true);
		var xPathFalse1 = new XPathBoolean(false);
		var xPathFalse2 = new XPathBoolean(false);
		
		assertFalse(xPathTrue1.notEqual(xPathTrue1).getBool());
		assertFalse(xPathTrue1.notEqual(xPathTrue2).getBool());
		assertTrue(xPathTrue1.notEqual(xPathFalse1).getBool());
		assertTrue(xPathTrue1.notEqual(xPathFalse2).getBool());
		assertFalse(xPathTrue2.notEqual(xPathTrue1).getBool());
		assertTrue(xPathFalse1.notEqual(xPathTrue1).getBool());
		assertFalse(xPathFalse1.notEqual(xPathFalse1).getBool());
		assertFalse(xPathFalse1.notEqual(xPathFalse2).getBool());
	}
	
	function testLessThanOrEqual () {
		var xPathTrue = new XPathBoolean(true);
		var xPathFalse = new XPathBoolean(false);
		
		assertTrue(xPathTrue.lessThanOrEqual(xPathTrue).getBool());
		assertFalse(xPathTrue.lessThanOrEqual(xPathFalse).getBool());
		assertTrue(xPathFalse.lessThanOrEqual(xPathTrue).getBool());
		assertTrue(xPathFalse.lessThanOrEqual(xPathFalse).getBool());
	}
	
	function testGreaterThanOrEqual () {
		var xPathTrue = new XPathBoolean(true);
		var xPathFalse = new XPathBoolean(false);
		
		assertTrue(xPathTrue.greaterThanOrEqual(xPathTrue).getBool());
		assertTrue(xPathTrue.greaterThanOrEqual(xPathFalse).getBool());
		assertFalse(xPathFalse.greaterThanOrEqual(xPathTrue).getBool());
		assertTrue(xPathFalse.greaterThanOrEqual(xPathFalse).getBool());
	}
	
	function testLessThan () {
		var xPathTrue = new XPathBoolean(true);
		var xPathFalse = new XPathBoolean(false);
		
		assertFalse(xPathTrue.lessThan(xPathTrue).getBool());
		assertFalse(xPathTrue.lessThan(xPathFalse).getBool());
		assertTrue(xPathFalse.lessThan(xPathTrue).getBool());
		assertFalse(xPathFalse.lessThan(xPathFalse).getBool());
	}
	
	function testGreaterThan () {
		var xPathTrue = new XPathBoolean(true);
		var xPathFalse = new XPathBoolean(false);
		
		assertFalse(xPathTrue.greaterThan(xPathTrue).getBool());
		assertTrue(xPathTrue.greaterThan(xPathFalse).getBool());
		assertFalse(xPathFalse.greaterThan(xPathTrue).getBool());
		assertFalse(xPathFalse.greaterThan(xPathFalse).getBool());
	}
	
	function testUnion () {
		var caught = false;
		try {
			new XPathBoolean(false).union(new XPathNodeSet([]));
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
}
